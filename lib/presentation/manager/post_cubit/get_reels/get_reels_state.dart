import 'package:auth/domain/entities/post.dart';

abstract class ReelsState {}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final List<Post> reels;
  final bool hasReachedMax;

  ReelsLoaded({required this.reels, this.hasReachedMax = false});
}

class ReelsError extends ReelsState {
  final String message;
  ReelsError(this.message);
}