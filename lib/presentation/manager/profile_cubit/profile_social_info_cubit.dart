import 'package:auth/domain/entities/follow.dart';
import 'package:auth/domain/usecases/follow/accept_follow_requests.dart';
import 'package:auth/domain/usecases/follow/decline_follow_requests.dart';
import 'package:auth/domain/usecases/follow/get_my_follow_requests.dart';
import 'package:auth/domain/usecases/follow/get_my_followers.dart';
import 'package:auth/domain/usecases/follow/get_my_following.dart';
import 'package:auth/domain/usecases/follow/get_user_followers.dart';
import 'package:auth/domain/usecases/follow/get_user_following.dart';
import 'package:auth/domain/usecases/user_profile/get_suggestions.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSocialInfoCubit extends Cubit<ProfileSocialInfoState> {
  final GetMyFollowers getMyFollowersUseCase;
  final GetMyFollowing getMyFollowingUseCase;
  final GetUserFollowers getUserFollowersUseCase;
  final GetUserFollowing getUserFollowingUseCase;
  final GetMyFollowRequests getMyFollowRequestsUseCase;
  final AcceptFollowRequest acceptFollowRequest;
  final DeclineFollowRequest declineFollowRequest;
  final GetSuggestions getSuggestionsUseCase;

  ProfileSocialInfoCubit({
    required this.getMyFollowersUseCase,
    required this.getMyFollowingUseCase,
    required this.getUserFollowersUseCase,
    required this.getUserFollowingUseCase,
    required this.getMyFollowRequestsUseCase,
    required this.acceptFollowRequest,
    required this.declineFollowRequest, 
    required this.getSuggestionsUseCase,
  }) : super(SocialInfoInitial());

  int _followersPage = 1;
  int _followingPage = 1;
  final int _limit = 10;

  Future<void> fetchFollowers({String? userId, bool loadMore = false}) async {
    final currentState = state;
    if (!loadMore &&
        state is SocialInfoLoaded &&
        (state as SocialInfoLoaded).followers.isNotEmpty) {
      return;
    }
    if (!loadMore) {
      _followersPage = 1;
      if (currentState is! SocialInfoLoaded) emit(SocialInfoLoading());
    }

    final result = (userId == null)
        ? await getMyFollowersUseCase.call(page: _followersPage, limit: _limit)
        : await getUserFollowersUseCase.call(userId: userId);

    result.fold(
      (failure) => emit(SocialInfoFailure(failure.message)), 
      (newItems) {
        final isMax = newItems.length < _limit;
        if (state is SocialInfoLoaded) {
          final loadedState = state as SocialInfoLoaded;
          List<Follow> previousItems = loadMore ? loadedState.followers : [];
          
          emit(loadedState.copyWith(
            followers: [...previousItems, ...newItems],
            hasReachedMaxFollowers: isMax,
          ));
        } else {
          emit(SocialInfoLoaded(
            followers: newItems,
            hasReachedMaxFollowers: isMax,
            following: const [],
            requests: const [],
          ));
        }
        _followersPage++;
      },
    );
  }

  Future<void> fetchFollowing({String? userId, bool loadMore = false}) async {
    if (!loadMore) {
      _followingPage = 1;
      if (state is! SocialInfoLoaded) emit(SocialInfoLoading());
    }

    final result = (userId == null)
        ? await getMyFollowingUseCase.call(page: _followingPage, limit: _limit)
        : await getUserFollowingUseCase.call(userId: userId);

    result.fold(
      (failure) => emit(SocialInfoFailure(failure.message)), 
      (newItems) {
        final isMax = newItems.length < _limit;

        if (state is SocialInfoLoaded) {
          final loadedState = state as SocialInfoLoaded;
          emit(loadedState.copyWith(
            following: List.from(newItems),
            hasReachedMaxFollowing: newItems.length < _limit,
          ));
        } else {
          emit(SocialInfoLoaded(
            following: List.from(newItems),
            hasReachedMaxFollowing: isMax,
          ));
        }
        _followingPage++;
      },
    );
  }

  Future<void> fetchRequests() async {
    if (state is! SocialInfoLoaded) emit(SocialInfoLoading());

    final result = await getMyFollowRequestsUseCase.call();
    
    result.fold(
      (failure) => emit(SocialInfoFailure(failure.message)), 
      (requests) {
        if (state is SocialInfoLoaded) {
          emit((state as SocialInfoLoaded).copyWith(requests: requests));
        } else {
          emit(SocialInfoLoaded(requests: requests));
        }
      },
    );
  }

  Future<void> acceptRequest(String requestId) async {
    if (state is SocialInfoLoaded) {
      final currentState = state as SocialInfoLoaded;

      emit(const SocialActionSuccess("Request accepted (Local)"));

      final updatedRequests = currentState.requests
          .where((req) => req.id != requestId)
          .toList();

      emit(currentState.copyWith(requests: updatedRequests));
      
      //print("✅ Mocked Accept for ID: $requestId. No API call made.");
    }
  }

  Future<void> declineRequest(String requestId) async {
    if (state is SocialInfoLoaded) {
      final currentState = state as SocialInfoLoaded;

      emit(const SocialActionSuccess("Request declined (Local)"));

      final updatedRequests = currentState.requests
          .where((req) => req.id != requestId)
          .toList();

      emit(currentState.copyWith(requests: updatedRequests));
    }
  }
  
Future<void> fetchSuggestions() async {
    if (state is! SocialInfoLoaded) emit(SocialInfoLoading());

    final result = await getSuggestionsUseCase.call();

    result.fold(
      (failure) => emit(SocialInfoFailure(failure.message)),
      (suggestions) {
        if (state is SocialInfoLoaded) {
          final loadedState = state as SocialInfoLoaded;
          emit(loadedState.copyWith(suggestions: suggestions));
        } else {
          emit(SocialInfoLoaded(
            suggestions: suggestions,
            followers: const [],
            following: const [],
            requests: const [],
          ));
        }
      },
    );
  }
void toggleFollowOptimistically(String targetId, bool currentlyFollowing) {
  if (state is SocialInfoLoaded) {
    final currentState = state as SocialInfoLoaded;
    List<Follow> updatedList = List.from(currentState.following);

    if (currentlyFollowing) {
      // Remove immediately
      updatedList.removeWhere((f) => f.user.id == targetId);
    } else {
      // Add a dummy entry immediately
      updatedList.add(Follow(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        user: UserReference.fromJson(targetId),
        follower: UserReference.fromJson('me'),
        status: 'following',
      ));
    }

    emit(currentState.copyWith(following: updatedList));
  }
}
}
