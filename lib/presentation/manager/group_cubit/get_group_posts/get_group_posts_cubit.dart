import 'package:auth/presentation/manager/group_cubit/get_group_posts/get_group_posts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/group/group_posts/get_group_posts_use_case.dart';

class GetGroupPostsCubit extends Cubit<GetGroupPostsState> {
  final GetGroupPostsUseCase getGroupPostsUseCase;

  GetGroupPostsCubit({ required this.getGroupPostsUseCase}) : super(GetGroupPostsInitial());

  List<Post> posts = [];
  int page = 1;
  bool isFetching = false;

  Future<void> getPosts({required String groupId, bool refresh = false}) async {
    if (isFetching) return;

    if (refresh) {
      page = 1;
      posts = [];
      emit(GetGroupPostsLoading());
    }

    isFetching = true;

    final result = await getGroupPostsUseCase(groupId: groupId, page: page);

    result.fold(
      (failure) {
        isFetching = false;
        emit(GetGroupPostsError(failure.message));
      },
      (newPosts) {
        isFetching = false;
        if (newPosts.isEmpty && page > 1) {
          emit(GetGroupPostsLoaded(List.from(posts)));
          return;
        }

        posts.addAll(newPosts);
        page++;
        emit(GetGroupPostsLoaded(List.from(posts)));
      },
    );
  }

  void addPostOptimistically(Post post) {
    posts.insert(0, post);
    emit(GetGroupPostsLoaded(List.from(posts)));
  }
}
