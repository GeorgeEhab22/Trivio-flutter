import 'package:auth/domain/entities/post.dart';
import 'package:equatable/equatable.dart';

abstract class GetGroupsPostsFeedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetGroupsPostsFeedInitial extends GetGroupsPostsFeedState {}
class GetGroupsPostsFeedLoading extends GetGroupsPostsFeedState {}

class GetGroupsPostsFeedLoaded extends GetGroupsPostsFeedState {
  final List<Post> posts;
  final bool hasReachedMax; 

  GetGroupsPostsFeedLoaded({required this.posts, this.hasReachedMax = false});

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class GetGroupsPostsFeedError extends GetGroupsPostsFeedState {
  final String message;
  GetGroupsPostsFeedError(this.message);

  @override
  List<Object?> get props => [message];
}
