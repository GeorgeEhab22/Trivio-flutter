// verify_code_cubit.dart
import 'dart:async';

import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/usecases/rigester/resend_verification_code.dart';
import 'package:auth/domain/usecases/rigester/verify_code.dart';
import 'package:auth/presentation/manager/register_cubit/cubit/verify_code_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  final VerifyCode verifyCode;
  final ResendVerificationCode resendVerificationCode;

  final String email;
  Timer? _resendTimer;
  int _resendCountdown = 0;

  VerifyCodeCubit({
    required this.verifyCode,
    required this.resendVerificationCode,
    required this.email,
  }) : super(const VerifyCodeInitial());

  int get resendCountdown => _resendCountdown;
  bool get canResend => _resendCountdown == 0;

  /// Starts (or restarts) the resend countdown. Emits VerifyCodeCountdown immediately
  /// and every second until it reaches 0.
  void startResendTimer({int seconds = 60}) {
    // cancel any existing timer
    _resendTimer?.cancel();

    // defensive: ensure seconds >= 0
    _resendCountdown = (seconds < 0) ? 0 : seconds;

    // Emit immediately so UI shows the initial countdown right away.
    emit(VerifyCodeCountdown(_resendCountdown));
    // debug
    // ignore: avoid_print
    print('[VerifyCodeCubit] startResendTimer -> $_resendCountdown seconds');

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _resendCountdown--;

      if (_resendCountdown <= 0) {
        _resendCountdown = 0;
        timer.cancel();
        // final emit at 0
        emit(const VerifyCodeCountdown(0));
        // debug
        // ignore: avoid_print
        print('[VerifyCodeCubit] countdown finished');
        return;
      }

      // emit the new countdown value
      emit(VerifyCodeCountdown(_resendCountdown));
      // debug
      // ignore: avoid_print
      print('[VerifyCodeCubit] countdown tick -> $_resendCountdown');
    });
  }

  Future<void> verify(String code) async {
    if (code.length != 6) {
      emit(const VerifyCodeError('Please enter a valid 6-digit code.'));
      return;
    }

    emit(const VerifyCodeLoading());

    final result = await verifyCode(email: email, code: code);

    result.fold(
      (failure) => emit(VerifyCodeError(_mapFailureToMessage(failure))),
      (token) => emit(VerifyCodeSuccess(token: token)),
    );
  }

  Future<void> resend() async {
    if (!canResend) return;

    emit(const VerifyCodeResending());

    final result = await resendVerificationCode(email);

    result.fold(
      (failure) => emit(VerifyCodeError(_mapFailureToMessage(failure))),
      (_) {
        emit(const VerifyCodeResent());
        // restart countdown after resending
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
    _resendTimer?.cancel();
    return super.close();
  }
}
