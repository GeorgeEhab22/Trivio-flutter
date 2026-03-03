import 'package:auth/domain/entities/join_request.dart';
import 'package:auth/domain/usecases/group/get_join_requests_use_case.dart';
import 'package:auth/presentation/manager/groups_pagination/base_pagination_cubit.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:dartz/dartz.dart';

class GetJoinRequestsCubit extends BasePaginationCubit<JoinRequest> {
  final GetJoinRequestsUseCase getJoinRequestsUseCase;
  late String groupId;

  GetJoinRequestsCubit({required this.getJoinRequestsUseCase});

  @override
  Future<Either<dynamic, List<JoinRequest>>> fetchUseCase({int page = 1}) {
    return getJoinRequestsUseCase(groupId: groupId, page: page);
  }

  @override
  String getItemId(JoinRequest item) => item.requestId;

  void removeRequestLocally(String requestId) {
    items.removeWhere((r) => r.requestId == requestId);
    emit(
      PaginationLoaded<JoinRequest>(
        items: List.from(items),
        hasReachedMax: hasReachedMax,
      ),
    );
  }
}
