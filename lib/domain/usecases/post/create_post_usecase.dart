import 'dart:io';
import 'dart:typed_data';

import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class CreatePostUseCase {
  final PostRepository repository;

  // max post content
  static const int maxContentLength = 500;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, Post>> call({
    required String userId,
    String? content,
    List<XFile>? media,
    List<String>? tags,
  }) async {
    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure('User ID is required'));
    }

    if (!Validator.isValidId(userId)) {
      return const Left(ValidationFailure('Invalid User ID'));
    }

    final trimmedContent = content?.trim() ?? '';

    final imageExts = <String>{
      'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif', 'bmp'
    };
    final videoExts = <String>{
      'mp4', 'mov', 'avi', 'mkv', 'flv', 'webm', 'm4v', '3gp'
    };

    final List<XFile> imageFiles = [];
    final List<XFile> videoFiles = [];

    if (media != null && media.isNotEmpty) {
      for (final xfile in media) {
        final ext = await _detectExtensionFromXFile(xfile);
        if (ext.isEmpty) {
          continue;
        }
        if (imageExts.contains(ext)) {
          imageFiles.add(xfile);
        } else if (videoExts.contains(ext)) {
          videoFiles.add(xfile);
        } else {
        }
      }
    }

    if (trimmedContent.isEmpty && imageFiles.isEmpty && videoFiles.isEmpty) {
      return const Left(
        ValidationFailure('Post must have text or an image or video'),
      );
    }

    if (trimmedContent.length > maxContentLength) {
      return Left(
        ValidationFailure(
          'Post content cannot exceed $maxContentLength characters',
        ),
      );
    }

    // Convert the first image/video XFile to dart:io File (if present)
    final File? image =
        imageFiles.isNotEmpty ? File(imageFiles.first.path) : null;
    final File? video =
        videoFiles.isNotEmpty ? File(videoFiles.first.path) : null;

    if (image != null && !Validator.validatePickedImage(image)) {
      return const Left(ValidationFailure('Invalid image file'));
    }

    if (video != null && !Validator.validatePickedVideo(video)) {
      return const Left(ValidationFailure('Invalid video file'));
    }

    return await repository.createPost(
      userId: userId,
      content: trimmedContent,
      image: image,
      video: video,
      tags: tags,
    );
  }

  // Try extension from path first; if missing, detect mime from header bytes.
  static Future<String> _detectExtensionFromXFile(XFile xfile) async {
    try {
      // 1) try extension from path/name
      final cleaned = xfile.path.split('?').first.split('#').first;
      final extWithDot = p.extension(cleaned); // e.g. '.jpg' or ''
      if (extWithDot.isNotEmpty) {
        return extWithDot.replaceFirst('.', '').toLowerCase();
      }

      // 2) read header bytes and detect mime
      final header = await _readHeaderBytes(xfile, 512);
      if (header.isEmpty) return '';

      final mime = lookupMimeType('', headerBytes: header);
      if (mime == null) return '';

      final subtype = mime.split('/').last.toLowerCase();
      return _mimeSubtypeToExtension(subtype);
    } catch (e) {
      return '';
    }
  }

  static Future<Uint8List> _readHeaderBytes(XFile xfile, [int length = 512]) async {
    try {
      final stream = xfile.openRead(0, length);
      final chunks = <int>[];
      await for (final chunk in stream) {
        chunks.addAll(chunk);
        if (chunks.length >= length) break;
      }
      return Uint8List.fromList(chunks);
    } catch (e) {
      try {
        final all = await xfile.readAsBytes();
        return Uint8List.fromList(all.take(length).toList());
      } catch (_) {
        return Uint8List(0);
      }
    }
  }

  static String _mimeSubtypeToExtension(String subtype) {
    switch (subtype) {
      case 'jpeg':
        return 'jpg';
      case 'tiff':
        return 'tif';
      // video subtypes commonly match extension name
      default:
        return subtype;
    }
  }
}
