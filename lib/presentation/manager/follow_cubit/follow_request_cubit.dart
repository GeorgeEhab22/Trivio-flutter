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

    final result = await getMyFollowRequestsUseCase.call ();

    result.fold(
      (failure) => emit(FollowRequestFailure(failure.message)),
      (requests) => emit(FollowRequestLoaded(requests)),
    );
  }

  Future<void> acceptRequest(String requestId) async {
    emit(FollowRequestLoading());

    final result = await acceptFollowRequestUseCase.call(requestId: requestId);

    result.fold(
      (failure) => emit(FollowRequestFailure(failure.message)),
      (_) => emit(const FollowRequestActionSuccess("Request accepted")),
    );
  }

  Future<void> declineRequest(String requestId) async {
    emit(FollowRequestLoading());

    final result =
        await declineFollowRequestUseCase.call(requestId: requestId);

    result.fold(
      (failure) => emit(FollowRequestFailure(failure.message)),
      (_) => emit(const FollowRequestActionSuccess("Request declined")),
    );
  }
}
