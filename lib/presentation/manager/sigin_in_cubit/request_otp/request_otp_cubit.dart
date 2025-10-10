import 'package:auth/core/validator.dart';
import 'package:auth/domain/usecases/sign_in/request_otp.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RequestOTPCubit extends Cubit<RequestOTPState> {
  final SendPasswordResetOtp sendPasswordResetOtp;

  RequestOTPCubit({required this.sendPasswordResetOtp, })
      : super(RequestOTPInitial());



  Future<void> sendOtp(String email) async {
    emit(RequestOTPLoading());
    try {
      if (!Validator.isValidEmail(email)) {
        emit(RequestOTPFailure('Please enter a valid email address'));
        return;
      }
      final result = await sendPasswordResetOtp(email: email);
      result.fold(
        (failure) => emit(RequestOTPFailure(failure.message)),
        (message) => emit(RequestOTPSuccess()),
      );
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      emit(RequestOTPFailure('Failed to send OTP. Please try again.'));
    }
  }
}