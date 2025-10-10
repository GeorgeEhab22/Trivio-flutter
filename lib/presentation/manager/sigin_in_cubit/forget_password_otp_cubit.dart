import 'package:auth/domain/usecases/sign_in/verify_otp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forget_password_otp_state.dart';

class ForgetPasswordOTPCubit extends Cubit<ForgetPasswordOTPState> {
  
  final VerifyOTP verifyOTP;
  ForgetPasswordOTPCubit({
  
    required this.verifyOTP,
  }) : super(ForgetPasswordOTPInitial());
  Future<void> verifyOtp(
    String otp,
    String email,
    String password,
    String confirmPassword,
  ) async {
    emit(ForgetPasswordOTPLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      final result = await verifyOTP(
        otp: otp,
        email: email,
        password: password,
        confirmPassword: password,
      );
      result.fold(
        (failure) => emit(ForgetPasswordOTPFailure(failure.message)),
        (user) => emit(ForgetPasswordOTPSuccess()),
      );
    } catch (e) {
      emit(ForgetPasswordOTPFailure('Failed to verify OTP. Please try again.'));
    }
  }
}
