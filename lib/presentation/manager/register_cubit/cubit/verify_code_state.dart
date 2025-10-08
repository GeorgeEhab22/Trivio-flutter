abstract class VerifyCodeState {
  const VerifyCodeState();
}

class VerifyCodeInitial extends VerifyCodeState {
  const VerifyCodeInitial();
}

class VerifyCodeLoading extends VerifyCodeState {
  const VerifyCodeLoading();
}

class VerifyCodeSuccess extends VerifyCodeState {
  final String? token;
  const VerifyCodeSuccess({required this.token});
}

class VerifyCodeError extends VerifyCodeState {
  final String message;
  const VerifyCodeError(this.message);
}

class VerifyCodeResending extends VerifyCodeState {
  const VerifyCodeResending();
}

class VerifyCodeResent extends VerifyCodeState {
  const VerifyCodeResent();
}

class VerifyCodeCountdown extends VerifyCodeState {
  final int seconds;
  const VerifyCodeCountdown(this.seconds);
}
