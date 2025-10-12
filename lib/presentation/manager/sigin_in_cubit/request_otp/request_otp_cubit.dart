import 'dart:async';
import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/usecases/sign_in/request_otp.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestOTPCubit extends Cubit<RequestOTPState> {
  final SendPasswordResetOtp sendPasswordResetOtp;

  Timer? _resendTimer;
  int _resendCountdown = 0;

  RequestOTPCubit({required this.sendPasswordResetOtp})
    : super(const RequestOTPInitial()){
        print('✅ RequestOTPCubit created $hashCode');

    }

  int get resendCountdown => _resendCountdown;
  bool get canResend => _resendCountdown == 0;

  void startResendTimer({int seconds = 60}) {
    print('🔁 Starting resend timer...');
    _resendTimer?.cancel();
    _resendCountdown = seconds;
    emit(RequestOTPCountdown(_resendCountdown));

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _resendCountdown--;
      print('Countdown: $_resendCountdown');
      if (_resendCountdown <= 0) {
        _resendCountdown = 0;
        timer.cancel();
        emit(const RequestOTPCountdown(0));
      } else {
        emit(RequestOTPCountdown(_resendCountdown));
      }
    });
  }

  Future<void> sendOtp(String email) async {
    if (!Validator.isValidEmail(email)) {
      emit(const RequestOTPFailure('Please enter a valid email address.'));
      return;
    }

    emit(const RequestOTPLoading());

    final result = await sendPasswordResetOtp(email: email);
    result.fold(
      (failure) => emit(RequestOTPFailure(_mapFailureToMessage(failure))),
      (_) {
        emit(const RequestOTPSuccess());
        startResendTimer();
      },
    );
  }

  Future<void> resendOtp(String email) async {
    if (!canResend) return;
    emit(const RequestOTPLoading());

    final result = await sendPasswordResetOtp(email: email);
    result.fold(
      (failure) => emit(RequestOTPFailure(_mapFailureToMessage(failure))),
      (_) {
        emit(const RequestOTPResent());
        startResendTimer();
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return 'No internet connection';
    } else if (failure is ValidationFailure) {
      return failure.message;
    }
    return 'An unexpected error occurred';
  }

  @override
  Future<void> close() {
      print('❌ RequestOTPCubit closed');

    _resendTimer?.cancel();
    return super.close();
  }
}
