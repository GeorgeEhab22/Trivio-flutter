import 'package:auth/domain/usecases/user_profile/change_password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePassword changePasswordUseCase;

  ChangePasswordCubit({required this.changePasswordUseCase}) 
      : super(ChangePasswordInitial());

  Future<void> updatePassword(String current, String next) async {
    emit(ChangePasswordLoading());

    final result = await changePasswordUseCase(current, next);

    result.fold(
      (failure) => emit(ChangePasswordError(failure.message)),
      (_) => emit(const ChangePasswordSuccess("Password changed successfully!")),
    );
  }
}