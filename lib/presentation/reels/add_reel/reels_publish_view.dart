import 'dart:io';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/post_cubit/create_post_cubit.dart';
import 'package:auth/presentation/reels/add_reel/widgets/publish_controls_overlay.dart';
import 'package:auth/presentation/reels/add_reel/widgets/reels_publish_view_app_bar.dart';
import 'package:auth/presentation/reels/add_reel/widgets/video_preview.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ReelsPublishView extends StatefulWidget {
  final XFile videoFile;
  const ReelsPublishView({super.key, required this.videoFile});

  @override
  State<ReelsPublishView> createState() => _ReelsPublishViewState();
}

class _ReelsPublishViewState extends State<ReelsPublishView> {
  late VideoPlayerController _controller;
  final TextEditingController _captionController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    if (kIsWeb) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoFile.path),
      );
    } else {
      _controller = VideoPlayerController.file(File(widget.videoFile.path));
    }

    _controller.setVolume(0);
    _controller.setLooping(false);

    _controller
        .initialize()
        .then((_) {
          if (!mounted) return;

          _controller.addListener(() {
            if (mounted) setState(() {});
          });

          setState(() {
            _isInitialized = true;
          });

          _controller.play();

          Future.delayed(
            const Duration(seconds: 1),
            () => _controller.setVolume(1.0),
          );
        })
        .catchError((error) {
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<CreatePostCubit>(),
      child: BlocConsumer<CreatePostCubit, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostSuccess) {
            context.pop();
            showCustomSnackBar(context, "Reel shared successfully!", true);
          } else if (state is CreatePostError) {
            showCustomSnackBar(context, state.message, false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: false,
            appBar: ReelsPublishViewAppBar(
              videoFile: widget.videoFile,
              caption: _captionController.text,
            ),
            body: Stack(
              children: [
                if (_isInitialized)
                  VideoPreviewWidget(controller: _controller)
                else
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),

                if (_isInitialized)
                  state is CreatePostLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PublishControlsOverlay(
                          controller: _controller,
                          captionController: _captionController,
                        ),
              ],
            ),
          );
        },
      ),
    );
  }
}
