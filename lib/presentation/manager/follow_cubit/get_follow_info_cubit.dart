import 'package:auth/domain/usecases/follow/get_user_followers.dart';
import 'package:auth/domain/usecases/follow/get_user_following.dart';
import 'package:auth/presentation/manager/follow_cubit/get_follow_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowInfoCubit extends Cubit<FollowInfoState> {
  final GetUserFollowers getUserFollowersUseCase;
  final GetUserFollowing getUserFollowingUseCase;

  FollowInfoCubit({
    required this.getUserFollowersUseCase,
    required this.getUserFollowingUseCase,
  }) : super(FollowInfoInitial());

  /// Fetches the list of people following the target user
  Future<void> getFollowers(String userId) async {
    emit(FollowInfoLoading());

    final result = await getUserFollowersUseCase.call(userId: userId);

    result.fold(
      (failure) => emit(FollowInfoFailure(failure.message)),
      (data) => emit(FollowInfoLoaded(data: data)),
    );
  }

  /// Fetches the list of people the target user is following
  Future<void> getFollowing(String userId) async {
    emit(FollowInfoLoading());

    final result = await getUserFollowingUseCase.call(userId: userId);

    result.fold(
      (failure) => emit(FollowInfoFailure(failure.message)),
      (data) => emit(FollowInfoLoaded(data: data)),
    );
  }
}
