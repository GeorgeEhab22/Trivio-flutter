import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {
  const SignInInitial();
}

class SignInLoading extends SignInState {
  const SignInLoading();
}

class SignInSuccess extends SignInState {

  const SignInSuccess();

}

class SignInFailure extends SignInState {
  final String message;
  final String? errorType;

  const SignInFailure({
    required this.message,
    this.errorType,
  });

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isAuthError => errorType == 'auth';
}