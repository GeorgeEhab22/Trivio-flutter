import 'package:equatable/equatable.dart';



sealed class RequestOTPState extends Equatable {
  const RequestOTPState();
  @override
  List<Object> get props => [];
}

final class RequestOTPInitial extends RequestOTPState {}

final class RequestOTPLoading extends RequestOTPState {}

final class RequestOTPSuccess extends RequestOTPState {}

final class RequestOTPFailure extends RequestOTPState {
  final String message;
  const RequestOTPFailure(this.message);
}