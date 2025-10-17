
import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/user.dart';
import 'package:auth/domain/usecases/register/register_usecase.dart';
import 'package:auth/presentation/manager/register_cubit/cubit/register_state.dart';
import 'package:auth/services/social_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;
  final SocialAuthService socialAuthService = SocialAuthService();

  RegisterCubit({
    required RegisterUseCase registerUseCase,
  
  })  : _registerUseCase = registerUseCase,
       
        super(const RegisterInitial());

  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(const RegisterLoading());

    final result = await _registerUseCase(email: email, password: password, username: username);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (user) => emit(RegisterSuccess(user: user)),
    );
  }

  RegisterFailure _mapFailureToState(Failure failure) {
    switch (failure.runtimeType) {
      case const (ValidationFailure):
        return RegisterFailure(message: failure.message, errorType: 'validation');
      case const (NetworkFailure):
        return RegisterFailure(message: failure.message, errorType: 'network');
      case const (AuthFailure):
        return RegisterFailure(message: failure.message, errorType: 'auth');
      default:
        return RegisterFailure(message: failure.message, errorType: 'server');
    }
  }

  void resetState() => emit(const RegisterInitial());

  bool get isLoading => state is RegisterLoading;
  bool get isSuccess => state is RegisterSuccess;
  bool get isFailure => state is RegisterFailure;
  bool get isInitial => state is RegisterInitial;

  User? get currentUser =>
      state is RegisterSuccess ? (state as RegisterSuccess).user : null;

  String? get errorMessage =>
      state is RegisterFailure ? (state as RegisterFailure).message : null;
}
