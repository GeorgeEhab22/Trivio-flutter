import 'package:equatable/equatable.dart';
import 'package:auth/domain/entities/post.dart';

abstract class GetPostState extends Equatable {
  const GetPostState();

  @override
  List<Object?> get props => [];
}

class GetPostInitial extends GetPostState {}

class GetPostLoading extends GetPostState {}

class GetPostSuccess extends GetPostState {
  final Post post;
  const GetPostSuccess(this.post);

  @override
  List<Object?> get props => [post];
}

class GetPostFailure extends GetPostState {
  final String message;
  const GetPostFailure(this.message);

  @override
  List<Object?> get props => [message];
}