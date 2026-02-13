import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/usecases/follow/follow_user.dart';
import 'package:auth/domain/usecases/follow/unfollow_user.dart';
import 'package:auth/dummydata.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  final FollowUser followUserUseCase;
  final UnfollowUser unfollowUserUseCase;

  FollowCubit({
    required this.followUserUseCase,
    required this.unfollowUserUseCase,
  }) : super(FollowInitial());

  Future<void> followUser(String userId) async {
    emit(FollowLoading());

    final result = await followUserUseCase.call(userId: userId);

    result.fold(
      (failure) => emit(FollowFailure(failure.message)),
      (follow) => emit(FollowSuccess(follow: follow)),
    );
  }

  Future<void> unfollowUser(String userId) async {
    emit(FollowLoading());

    final result = await unfollowUserUseCase.call(userId: userId);

    result.fold(
      (failure) => emit(FollowFailure(failure.message)),
      (_) => emit(const FollowSuccess()),
    );
  }

  void debugForceSuccess() {
    emit(FollowSuccess(follow: DummyFollowData.followModel));
  }

  void debugForceUnfollow() {
    emit(FollowLoading());

    Future.delayed(const Duration(milliseconds: 500), () {
      // By passing null, the widget's 'isFollowing' check becomes false
      emit(FollowSuccess(follow: null));
    });
  }
}
