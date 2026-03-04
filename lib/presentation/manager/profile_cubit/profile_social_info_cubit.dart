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
      // Only emit loading if we don't have existing data to prevent flickering
      if (currentState is! SocialInfoLoaded) emit(SocialInfoLoading());
    }

    final result = (userId == null)
        ? await getMyFollowersUseCase.call(page: _followersPage, limit: _limit)
        : await getUserFollowersUseCase.call(userId: userId);

    result.fold(
      (failure) => emit(SocialInfoFailure(failure.message)), 
      (newItems) {
        final isMax = newItems.length < _limit;

        // CRITICAL: Check 'state' here, not 'currentState'
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
            following: const [], // Initialize empty to avoid nulls
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
          // Use current state's following list
          List<Follow> previousItems = loadMore ? loadedState.following : [];
          
          emit(loadedState.copyWith(
            following: [...previousItems, ...newItems],
            hasReachedMaxFollowing: isMax,
          ));
        } else {
          // If this is the first data to arrive, create the state
          emit(SocialInfoLoaded(
            following: newItems,
            hasReachedMaxFollowing: isMax,
          ));
        }
        _followingPage++;
      },
    );
  }

  Future<void> fetchRequests() async {
    // Only show full-screen loading if we have absolutely nothing
    if (state is! SocialInfoLoaded) emit(SocialInfoLoading());

    final result = await getMyFollowRequestsUseCase.call();
    
    result.fold(
      (failure) => emit(SocialInfoFailure(failure.message)), 
      (requests) {
        if (state is SocialInfoLoaded) {
          // Keep followers and following, just update requests
          emit((state as SocialInfoLoaded).copyWith(requests: requests));
        } else {
          emit(SocialInfoLoaded(requests: requests));
        }
      },
    );
  }

// /// 🔹 Accept Follow Request (Mocked)
//  Future<void> acceptRequest(String requestId) async {
//     final result = await acceptFollowRequest.call(requestId: requestId);

//     result.fold((failure) {
//       // PRINT THIS FOR YOUR BACKEND TEAM
//       print("🚨 BACKEND AUTH ERROR:");
//       print("Endpoint: PATCH /api/v1/follow-requests/$requestId/accept");
//       print("Failure Message: ${failure.message}");
      
//       emit(SocialInfoFailure(failure.message));
//     }, (_) {
//       emit(const SocialActionSuccess("Request accepted"));
//       fetchRequests();
//     });
//   }
//   /// 🔹 Decline Follow Request (Mocked)
//   Future<void> declineRequest(String requestId) async {
//     if (state is SocialInfoLoaded) {
//       final currentState = state as SocialInfoLoaded;

//       emit(const SocialActionSuccess("Request declined"));

//       // Manually remove the declined request
//       final updatedRequests = currentState.requests
//           .where((req) => req.id != requestId)
//           .toList();

//       emit(currentState.copyWith(requests: updatedRequests));
//     }
//   }
/// 🔹 Accept Follow Request (Temporary Local Fix)
  Future<void> acceptRequest(String requestId) async {
    if (state is SocialInfoLoaded) {
      final currentState = state as SocialInfoLoaded;

      // 1. Show the success snackbar immediately
      emit(const SocialActionSuccess("Request accepted (Local)"));

      // 2. Filter out the ID locally so it vanishes from the screen
      final updatedRequests = currentState.requests
          .where((req) => req.id != requestId)
          .toList();

      // 3. Emit the updated state WITHOUT calling the backend
      emit(currentState.copyWith(requests: updatedRequests));
      
      print("✅ Mocked Accept for ID: $requestId. No API call made.");
    }
  }

  /// 🔹 Decline Follow Request (Temporary Local Fix)
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
    // 1. Only show loading if we have absolutely no data yet
    if (state is! SocialInfoLoaded) emit(SocialInfoLoading());

    final result = await getSuggestionsUseCase.call();

    result.fold(
      (failure) => emit(SocialInfoFailure(failure.message)),
      (suggestions) {
        // 2. Check the LATEST state to avoid overwriting
        if (state is SocialInfoLoaded) {
          final loadedState = state as SocialInfoLoaded;
          emit(loadedState.copyWith(suggestions: suggestions));
        } else {
          // 3. If this is the first list to arrive, create the bucket
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
}
