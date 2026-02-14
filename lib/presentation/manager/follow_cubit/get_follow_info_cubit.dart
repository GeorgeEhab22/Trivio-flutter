import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/usecases/follow/get_my_followers.dart';
import 'package:auth/domain/usecases/follow/get_my_following.dart';
import 'package:auth/domain/usecases/follow/get_user_followers.dart';
import 'package:auth/domain/usecases/follow/get_user_following.dart';
import 'package:auth/presentation/manager/follow_cubit/get_follow_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowInfoCubit extends Cubit<FollowInfoState> {
  final GetUserFollowers getUserFollowersUseCase;
  final GetUserFollowing getUserFollowingUseCase;
  final GetMyFollowers getMyFollowersUseCase;
  final GetMyFollowing getMyFollowingUseCase;

  int _page = 1;
  final int _limit = 10;
  bool _hasReachedMax = false;
  List _currentData = [];

  FollowInfoCubit({
    required this.getUserFollowersUseCase,
    required this.getUserFollowingUseCase,
    required this.getMyFollowersUseCase,
    required this.getMyFollowingUseCase,
  }) : super(FollowInfoInitial());

  Future<void> getUserFollowers(String userId) async {
    emit(FollowInfoLoading());

    final result = await getUserFollowersUseCase.call(userId: userId);

    result.fold(
      (failure) => emit(FollowInfoFailure(failure.message)),
      (data) => emit(FollowInfoLoaded(data: data)),
    );
  }

  Future<void> getUserFollowing(String userId) async {
    emit(FollowInfoLoading());

    final result =
        await getUserFollowingUseCase.call(userId: userId);

    result.fold(
      (failure) => emit(FollowInfoFailure(failure.message)),
      (data) => emit(FollowInfoLoaded(data: data)),
    );
  }

Future<void> getMyFollowers({bool loadMore = false}) async {
  if (_hasReachedMax && loadMore) return;

  if (!loadMore) {
    _page = 1;
    _currentData = [];
    emit(FollowInfoLoading());
  }

  // --- MOCK SECTION ---
  await Future.delayed(const Duration(seconds: 1)); 

  final List mockFollowers = List.generate(5, (index) {
    return Follow(
      id: "req_foll_$index",
      status: "following",
      // Me (just an ID)
      user: UserReference.fromJson("my_id_123"), 
      // The person following me (Full Preview)
      follower: UserReference.fromJson({
        "_id": "follower_id_$index",
        "name": "Follower Name $index",
        "avatar": "https://i.pravatar.cc/150?u=f$index"
      }),
    );
  });

  _hasReachedMax = true; 
  _currentData.addAll(mockFollowers);

  emit(FollowInfoLoaded(
    data: List.from(_currentData),
    hasReachedMax: _hasReachedMax,
  ));
  // --- END MOCK ---

  /* Original Code:
  final result = await getMyFollowersUseCase.call(page: _page, limit: _limit);
  result.fold(
    (failure) => emit(FollowInfoFailure(failure.message)),
    (data) {
      if (data.length < _limit) _hasReachedMax = true;
      else _page++;
      _currentData.addAll(data);
      emit(FollowInfoLoaded(data: List.from(_currentData), hasReachedMax: _hasReachedMax));
    },
  );
  */
}

  Future<void> getMyFollowing({bool loadMore = false}) async {
  if (_hasReachedMax && loadMore) return;

  if (!loadMore) {
    _page = 1;
    _currentData = [];
    emit(FollowInfoLoading());
  }

  // --- MOCK SECTION ---
  await Future.delayed(const Duration(seconds: 1));

  final List mockFollowing = List.generate(5, (index) {
    return Follow(
      id: "req_ing_$index",
      status: "following",
      // The target user I follow (Full Preview)
      user: UserReference.fromJson({
        "_id": "following_id_$index",
        "name": "Following Target $index",
        "avatar": "https://i.pravatar.cc/150?u=i$index"
      }),
      // Me (just an ID)
      follower: UserReference.fromJson("my_id_123"), 
    );
  });

  _hasReachedMax = true;
  _currentData.addAll(mockFollowing);

  emit(FollowInfoLoaded(
    data: List.from(_currentData),
    hasReachedMax: _hasReachedMax,
  ));
  // --- END MOCK ---

  /* Original Code:
  final result = await getMyFollowingUseCase.call(page: _page, limit: _limit);
  result.fold(
    (failure) => emit(FollowInfoFailure(failure.message)),
    (data) {
      if (data.length < _limit) _hasReachedMax = true;
      else _page++;
      _currentData.addAll(data);
      emit(FollowInfoLoaded(data: List.from(_currentData), hasReachedMax: _hasReachedMax));
    },
  );
  */
}
}
