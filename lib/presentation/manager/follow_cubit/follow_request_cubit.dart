import 'package:auth/domain/entities/follow_request.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:auth/domain/usecases/follow/accept_follow_requests.dart';
import 'package:auth/domain/usecases/follow/decline_follow_requests.dart';
import 'package:auth/domain/usecases/follow/get_my_follow_requests.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'follow_request_state.dart';

class FollowRequestCubit extends Cubit<FollowRequestState> {
  final GetMyFollowRequests getMyFollowRequestsUseCase;
  final AcceptFollowRequest acceptFollowRequestUseCase;
  final DeclineFollowRequest declineFollowRequestUseCase;

  FollowRequestCubit({
    required this.getMyFollowRequestsUseCase,
    required this.acceptFollowRequestUseCase,
    required this.declineFollowRequestUseCase,
  }) : super(FollowRequestInitial());

  Future<void> getMyFollowRequests() async {
    emit(FollowRequestLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate network lag
  
  final List<FollowRequest> mockRequests = List.generate(5, (index) {
    return FollowRequest(
      id: "req_test_$index", // Unique ID for each card
      userId: "user_001",
      followerId: "follower_$index",
      follower: UserProfilePreview(
        id: "id_$index",
        name: "Request User $index",
        avatarUrl: "https://i.pravatar.cc/150?u=$index",
      ),
      status: "pending",
    );
  });
  emit(FollowRequestLoaded(mockRequests));
  //uncomment after testing
  // emit(FollowRequestLoaded(mockRequests));
  //   final result = await getMyFollowRequestsUseCase.call ();

  //   result.fold(
  //     (failure) => emit(FollowRequestFailure(failure.message)),
  //     (requests) => emit(FollowRequestLoaded(requests)),
  //   );
  }

  Future<void> acceptRequest(String requestId) async {
    emit(FollowRequestLoading());

    await Future.delayed(const Duration(milliseconds: 800));
  
    // Force a success state
    emit(const FollowRequestActionSuccess("Request accepted"));

    // final result = await acceptFollowRequestUseCase.call(requestId: requestId);

    // result.fold(
    //   (failure) => emit(FollowRequestFailure(failure.message)),
    //   (_) => emit(const FollowRequestActionSuccess("Request accepted")),
    // );
  }

  Future<void> declineRequest(String requestId) async {
    emit(FollowRequestLoading());

    await Future.delayed(const Duration(milliseconds: 800));
    emit(const FollowRequestActionSuccess("Request declined"));
    // final result =
    //     await declineFollowRequestUseCase.call(requestId: requestId);

    // result.fold(
    //   (failure) => emit(FollowRequestFailure(failure.message)),
    //   (_) => emit(const FollowRequestActionSuccess("Request declined")),
    // );
  }
}
