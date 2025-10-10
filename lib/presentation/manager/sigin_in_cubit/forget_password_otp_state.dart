part of 'forget_password_otp_cubit.dart';

sealed class ForgetPasswordOTPState extends Equatable {
  const ForgetPasswordOTPState();

  @override
  List<Object> get props => [];
}

final class ForgetPasswordOTPInitial extends ForgetPasswordOTPState {}
final class ForgetPasswordOTPLoading extends ForgetPasswordOTPState {}
final class ForgetPasswordOTPSuccess extends ForgetPasswordOTPState {}
final class ForgetPasswordOTPFailure extends ForgetPasswordOTPState {
  final String message;
  const ForgetPasswordOTPFailure(this.message);
}
