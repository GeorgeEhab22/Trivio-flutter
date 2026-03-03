import 'package:auth/domain/entities/group_member.dart';
import 'package:auth/domain/usecases/group/members/get_group_banned_members_use_case.dart';
import 'package:auth/presentation/manager/groups_pagination/base_pagination_cubit.dart';
import 'package:auth/presentation/manager/groups_pagination/pagination_state.dart';
import 'package:dartz/dartz.dart';

class GetBannedMembersCubit extends BasePaginationCubit<GroupMember> {
  final GetGroupBannedMembersUseCase getGroupBannedMembersUseCase;
  late String groupId;

  GetBannedMembersCubit({required this.getGroupBannedMembersUseCase});

  @override
  Future<Either<dynamic, List<GroupMember>>> fetchUseCase({int page = 1}) {
    return getGroupBannedMembersUseCase(groupId: groupId, page: page);
  }

  @override
  String getItemId(GroupMember item) => item.userId!;

  void removeMemberLocally(String userId) {
    items.removeWhere((m) => m.userId == userId);
    emit(
      PaginationLoaded<GroupMember>(
        items: List.from(items),
        hasReachedMax: hasReachedMax,
      ),
    );
  }
}
