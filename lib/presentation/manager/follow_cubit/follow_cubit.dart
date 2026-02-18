import 'package:auth/domain/usecases/follow/follow_user.dart';
import 'package:auth/domain/usecases/follow/unfollow_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  final FollowUser followUserUseCase;
  final UnfollowUser unfollowUserUseCase;

  FollowCubit({required this.followUserUseCase, required this.unfollowUserUseCase}) : super(FollowInitial());

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
}
