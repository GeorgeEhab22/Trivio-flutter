import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/domain/usecases/user_profile/get_user_profile_by_id.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'get_user_profile_by_id_state.dart';

class GetUserProfileByIdCubit extends Cubit<GetUserProfileByIdState> {
  final GetUserProfileByIdUseCase getUserProfileByIdUseCase;

  GetUserProfileByIdCubit({required this.getUserProfileByIdUseCase}) 
      : super(GetUserProfileByIdInitial());
  
  UserProfile? get user {
    if (state is GetUserProfileByIdLoaded) {
      return (state as GetUserProfileByIdLoaded).user;
    }
    return null;
  }

  Future<void> loadUserProfileById(String userId, {bool isRefresh = false}) async {
    if (!isRefresh || state is! GetUserProfileByIdLoaded) {
      emit(GetUserProfileByIdLoading());
    }

    final result = await getUserProfileByIdUseCase.call(userId);

    result.fold(
      (failure) => emit(GetUserProfileByIdError(failure.message)),
      (user) => emit(GetUserProfileByIdLoaded(user)),
    );
  }
}