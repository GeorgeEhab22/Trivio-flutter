import 'package:auth/domain/usecases/post/get_post_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/manager/post_cubit/get_post/get_post_state.dart'; // تأكدي من المسار

class GetPostCubit extends Cubit<GetPostState> {
  final GetPostUseCase getPostUseCase;

  GetPostCubit({required this.getPostUseCase}) : super(GetPostInitial());

  Future<void> getPost(String postId) async {
    emit(GetPostLoading());

    final result = await getPostUseCase(postId);

    result.fold(
      (failure) => emit(GetPostFailure(failure.message)),
      (post) => emit(GetPostSuccess(post)),
    );
  }
}