import 'package:equatable/equatable.dart';

abstract class RequestOTPState extends Equatable {
  const RequestOTPState();

  @override
  List<Object?> get props => [];
}

class RequestOTPInitial extends RequestOTPState {
  const RequestOTPInitial();
}

class RequestOTPLoading extends RequestOTPState {
  const RequestOTPLoading();
}

class RequestOTPSuccess extends RequestOTPState {
  const RequestOTPSuccess();
}

class RequestOTPResent extends RequestOTPState {
  const RequestOTPResent();
}

class RequestOTPFailure extends RequestOTPState {
  final String message;
  const RequestOTPFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class RequestOTPCountdown extends RequestOTPState {
  final int seconds;
  const RequestOTPCountdown(this.seconds);

  @override
  List<Object?> get props => [seconds];
}
