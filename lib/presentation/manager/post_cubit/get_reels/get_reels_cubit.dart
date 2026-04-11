import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/usecases/post/get_reels_usecase.dart';
import 'package:auth/presentation/manager/post_cubit/get_reels/get_reels_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelsCubit extends Cubit<ReelsState> {
  final GetReelsUseCase _getReelsUseCase;
  int _currentPage = 1;
  bool _isFetching = false;

  ReelsCubit({required GetReelsUseCase getReelsUseCase})
    : _getReelsUseCase = getReelsUseCase,
      super(ReelsInitial());

  Future<void> fetchReels({bool refresh = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (refresh) {
      _currentPage = 1;
      emit(ReelsLoading());
    } else if (state is ReelsInitial || state is ReelsError) {
      emit(ReelsLoading());
    } else if (state is ReelsLoaded && (state as ReelsLoaded).hasReachedMax) {
      _isFetching = false;
      return;
    }

    final result = await _getReelsUseCase(page: _currentPage);

    result.fold(
      (failure) {
        if (refresh || state is! ReelsLoaded) {
          emit(ReelsError(failure.message));
        }
        _isFetching = false;
      },
      (newReels) {
        if (refresh || state is! ReelsLoaded) {
          emit(ReelsLoaded(reels: newReels, hasReachedMax: newReels.isEmpty));
        } else {
          final currentState = state as ReelsLoaded;
          emit(
            ReelsLoaded(
              reels: currentState.reels + newReels,
              hasReachedMax: newReels.isEmpty,
            ),
          );
        }
        if (newReels.isNotEmpty) _currentPage++;
        _isFetching = false;
      },
    );
  }
  void incrementCommentsCount(String postId, {int by = 1}) {
    if (postId.trim().isEmpty || by == 0 || state is! ReelsLoaded) {
      return;
    }

    final currentState = state as ReelsLoaded;
    final index = currentState.reels.indexWhere((p) => p.postID == postId);
    
    if (index == -1) return;

    final currentReels = List<Post>.from(currentState.reels);
    final targetReel = currentReels[index];
    
    final currentCount = targetReel.commentsCount < 0 ? 0 : targetReel.commentsCount;
    final nextCount = (currentCount + by).clamp(0, 1 << 31).toInt();

    currentReels[index] = targetReel.copyWith(commentsCount: nextCount);

    emit(ReelsLoaded(
      reels: currentReels, 
      hasReachedMax: currentState.hasReachedMax
    ));
  }
  void updateReelCaptionLocally(String postId, String newCaption) {
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;
      
      final updatedReels = currentState.reels.map((reel) {
        if (reel.postID == postId) {
          return reel.copyWith(caption: newCaption);
        }
        return reel;
      }).toList();
      
      emit(ReelsLoaded(
        reels: updatedReels, 
        hasReachedMax: currentState.hasReachedMax
      ));
    }
  }
  void deleteReel({required Post post}) {
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;
      
      final updatedReels = currentState.reels.where((item) => item.postID != post.postID).toList();
      
      emit(ReelsLoaded(
        reels: updatedReels, 
        hasReachedMax: currentState.hasReachedMax
      ));
    }
  }
}
