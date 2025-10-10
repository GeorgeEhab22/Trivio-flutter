import 'package:auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final User user;

  const RegisterSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class RegisterFailure extends RegisterState {
  final String message;
  final String? errorType;

  const RegisterFailure({
    required this.message,
    this.errorType,
  });

  @override
  List<Object?> get props => [message, errorType];

  bool get isValidationError => errorType == 'validation';
  bool get isNetworkError => errorType == 'network';
  bool get isAuthError => errorType == 'auth';
}
