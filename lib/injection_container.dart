import 'package:auth/common/api_service.dart';
import 'package:auth/data/datasource/auth_remote_datasource.dart';
import 'package:auth/data/repositories/auth_repo_impl.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:auth/domain/usecases/rigester/apple_register_usecase.dart';
import 'package:auth/domain/usecases/rigester/google_register_usecase.dart';
import 'package:auth/domain/usecases/rigester/register_usecase.dart';
import 'package:auth/domain/usecases/sign_in/apple_sign_in_usecases.dart';
import 'package:auth/domain/usecases/sign_in/google_sign_in_usecases.dart';
import 'package:auth/domain/usecases/sign_in/signin_usecase.dart';
import 'package:auth/presentation/manager/register_cubit/cubit/register_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/cubit/sign_in_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(
    () => ApiService(baseUrl: "http://localhost:3500/api/v1/"),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(api: sl(), prefs: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => AppleSignInUseCase(sl()));

  sl.registerLazySingleton(() => RegisterUseCase( sl()));
  sl.registerLazySingleton(() => GoogleRegisterUseCase( sl()));
  sl.registerLazySingleton(() => AppleRegisterUseCase( sl()));

  


  sl.registerFactory(
    () => SignInCubit(
      signInUseCase: sl(),
      appleSignInUseCase: sl(),
      googleSignInUseCase: sl(),
    ),
  );

  sl.registerFactory( 
    () => RegisterCubit(
      registerUseCase: sl(),
      googleRegisterUseCase: sl(),
      appleRegisterUseCase: sl(),
    ),
  );
}
