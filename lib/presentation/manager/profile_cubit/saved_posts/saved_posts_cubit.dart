import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/post/get_post_usecase.dart';
import 'package:auth/domain/usecases/user_profile/get_saved_posts.dart';
import 'package:auth/domain/usecases/user_profile/save_post.dart';
import 'package:auth/domain/usecases/user_profile/unsave_post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'saved_posts_state.dart';

class SavedPostsCubit extends Cubit<SavedPostsState> {
  final GetSavedPosts getSavedPostsUseCase;
  final SavePost savePostUseCase;
  final UnsavePost unsavePostUseCase;
  final GetPostUseCase getPostUseCase;

  SavedPostsCubit({
    required this.getSavedPostsUseCase,
    required this.savePostUseCase,
    required this.unsavePostUseCase,
    required this.getPostUseCase,
  }) : super(SavedPostsInitial());

  final Map<String, Post> _postCache = {};

  Future<void> loadSavedPosts() async {
    if (isClosed) return;
    emit(SavedPostsLoading());

    final result = await getSavedPostsUseCase();

    result.fold((failure) => emit(SavedPostsError(failure.message)), (
      ids,
    ) async {
      if (ids.isEmpty) {
        emit(SavedPostsLoaded(const []));
        return;
      }

      List<Post> fullPosts = [];
      for (var id in ids) {
        final postResult = await getPostUseCase(id);
        postResult.fold((failure) {
          if (!isClosed) emit(SavedPostsError(failure.message));
        }, (post) => fullPosts.add(post));
      }

      if (!isClosed) emit(SavedPostsLoaded(fullPosts));
    });
  }

  Future<void> toggleSavePost(Post post) async {
    // 1. Add post to cache so we don't lose its data if backend returns null
    _postCache[post.postID] = post;

    List<Post> currentList = [];
    if (state is SavedPostsLoaded) {
      currentList = (state as SavedPostsLoaded).savedPosts;
    }

    final isSaved = currentList.any((p) => p.postID == post.postID);
    final updatedList = List<Post>.from(currentList);

    if (isSaved) {
      updatedList.removeWhere((p) => p.postID == post.postID);
      _postCache.remove(post.postID); // Remove from cache if unsaved
    } else {
      updatedList.add(post);
    }

    emit(SavedPostsLoaded(updatedList));

    final result = isSaved
        ? await unsavePostUseCase(post.postID)
        : await savePostUseCase(post.postID);

    result.fold(
      (failure) => emit(SavedPostsLoaded(currentList)), // Revert on error
      (_) => null,
    );
  }
}
