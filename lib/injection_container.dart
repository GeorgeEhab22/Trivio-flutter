import 'dart:io';

import 'package:auth/common/api_service.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/datasource/auth_remote_datasource.dart';
import 'package:auth/data/datasource/comments_remote_datasource.dart';
import 'package:auth/data/datasource/posts_remote_datasource.dart';
import 'package:auth/data/datasource/stats_local_datasource.dart';
import 'package:auth/data/datasource/stats_remote_datasource.dart';
import 'package:auth/data/repositories/auth_repo_impl.dart';
import 'package:auth/data/repositories/comment_repo_impl.dart';
import 'package:auth/data/repositories/post_repo_impl.dart';
import 'package:auth/data/repositories/stats_repo_impl.dart';
import 'package:auth/domain/repositories/auth_repo.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:auth/domain/repositories/post_repo.dart';
import 'package:auth/domain/repositories/stats_repo.dart';
import 'package:auth/domain/usecases/comment/add_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/edit_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/get_comments_usecase.dart';
import 'package:auth/domain/usecases/comment/get_replies_usecase.dart';
import 'package:auth/domain/usecases/comment/mention_users_in_comment_usecase.dart';
import 'package:auth/domain/usecases/comment/react_to_comment_usecase.dart';
import 'package:auth/domain/usecases/post/comment_on_post_usecase.dart';
import 'package:auth/domain/usecases/post/create_post_usecase.dart';
import 'package:auth/domain/usecases/post/delete_post_usecase.dart';
import 'package:auth/domain/usecases/post/edit_post_usecase.dart';
import 'package:auth/domain/usecases/post/fetch_posts_usecase.dart';
import 'package:auth/domain/usecases/post/fetch_single_post_usecase.dart';
import 'package:auth/domain/usecases/post/react_to_post_usecase.dart';
import 'package:auth/domain/usecases/post/remove_reaction_from_post_usecase.dart';
import 'package:auth/domain/usecases/post/report_post_usecase.dart';
import 'package:auth/domain/usecases/post/search_post_usecase.dart';
import 'package:auth/domain/usecases/post/share_post_usecase.dart';
import 'package:auth/domain/usecases/post/toggle_follow_user.dart';
import 'package:auth/domain/usecases/post/toggle_save_post_usecase.dart';
import 'package:auth/domain/usecases/register/register_usecase.dart';
import 'package:auth/domain/usecases/register/resend_verification_code.dart';
import 'package:auth/domain/usecases/register/verify_code.dart';
import 'package:auth/domain/usecases/sign_in/google_sign_in_and_rigester_usecases.dart';
import 'package:auth/domain/usecases/sign_in/request_otp.dart';

import 'package:auth/domain/usecases/sign_in/signin_usecase.dart';
import 'package:auth/domain/usecases/sign_in/verify_otp.dart';
import 'package:auth/domain/usecases/stats/stats_usecase.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/create_post_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/request_otp/request_otp_cubit.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
import 'package:auth/presentation/manager/stats_cubit/stats_cubit.dart';
import 'package:auth/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. External & Core
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  final statslocal = StatsLocalDatasource();
  await statslocal.init();

  String baseUrl = kIsWeb
      ? dotenv.env['LOCAL_URL']!
      : (Platform.isAndroid || Platform.isIOS
            ? dotenv.env['MOBILE_URL']!
            : dotenv.env['LOCAL_URL']!);

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => ApiService(baseUrl: baseUrl));
  sl.registerLazySingleton(() => ErrorHandler());

  // ==========================================================================
  // FEATURE: AUTHENTICATION
  // ==========================================================================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(api: sl(), prefs: sl(), errorHandler: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInAndRegisterUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyCode(sl()));
  sl.registerLazySingleton(() => ResendVerificationCode(sl()));
  sl.registerLazySingleton(() => SendPasswordResetOtp(sl()));
  sl.registerLazySingleton(() => VerifyOTP(sl()));

  // Cubits
  sl.registerFactory(
    () => SignInCubit(signInUseCase: sl(), googleSignInUseCase: sl()),
  );
  sl.registerFactory(() => RegisterCubit(registerUseCase: sl()));
  sl.registerFactory(() => RequestOTPCubit(sendPasswordResetOtp: sl()));

  // ==========================================================================
  // FEATURE: STATS (Football Data)
  // ==========================================================================
  sl.registerLazySingleton<StatsLocalDatasource>(() => StatsLocalDatasource());
  sl.registerLazySingleton<StatsRemoteDatasource>(
    () => StatsRemoteDatasourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<StatsRepository>(
    () => StatsRepoImpl(remoteDatasource: sl(), localDatasource: sl()),
  );
  sl.registerLazySingleton(() => StatsUseCase(sl()));
  sl.registerFactory(() => StatsCubit(sl()));

  // ==========================================================================
  // FEATURE: POSTS
  // ==========================================================================
  sl.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(api: sl(), prefs: sl(), errorHandler: sl()),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  sl.registerLazySingleton(() => EditPostUseCase(sl()));
  sl.registerLazySingleton(() => FetchPostsUseCase(sl()));
  sl.registerLazySingleton(() => FetchSinglePostUseCase(sl()));
  sl.registerLazySingleton(() => SearchPostsUseCase(sl()));
  sl.registerLazySingleton(() => ReportPostUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFollowUserUseCase(sl()));
  sl.registerLazySingleton(() => ToggleSavePostUseCase(sl()));
  sl.registerLazySingleton(() => ReactToPostUseCase(sl()));
  sl.registerLazySingleton(() => RemoveReactionFromPostUseCase(sl()));
  sl.registerLazySingleton(() => CommentOnPostUseCase(sl()));
  sl.registerLazySingleton(() => SharePostUseCase(sl()));

  // Cubits
  sl.registerFactory(() => PostCubit(sl()));
  sl.registerFactory(() => CreatePostCubit(createPostUseCase: sl()));
  sl.registerFactory(
    () => PostInteractionCubit(
      reactToPostUseCase: sl(),
      sharePostUseCase: sl(),
      commentOnPostUseCase: sl(),
      toggleFollowUserUseCase: sl(),
      toggleSavePostUseCase: sl(),
      reportPostUseCase: sl(),
      removeReactionFromPostUseCase: sl(),
      deletePostUseCase: sl(),
      editPostUseCase: sl(),
    ),
  );

  // ==========================================================================
  // FEATURE: COMMENTS
  // ==========================================================================
  sl.registerLazySingleton<CommentsRemoteDataSource>(
    () => CommentsRemoteDataSourceImpl(
      api: sl(),
      prefs: sl(),
      errorHandler: sl(),
    ),
  );
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => AddCommentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(sl()));
  sl.registerLazySingleton(() => EditCommentUseCase(sl()));
  sl.registerLazySingleton(() => GetCommentsUseCase(sl()));
  sl.registerLazySingleton(() => GetRepliesUseCase(sl()));
  sl.registerLazySingleton(() => MentionUsersInCommentUseCase(sl()));
  sl.registerLazySingleton(() => ReactToCommentUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => CommentCubit(
      addCommentUseCase: sl(),
      deleteCommentUseCase: sl(),
      editCommentUseCase: sl(),
      getCommentsUseCase: sl(),
      getRepliesUseCase: sl(),
      mentionUsersInCommentUseCase: sl(),
      reactToCommentUseCase: sl(),
    ),
  );

  // ==========================================================================
  // CORE / GLOBAL
  // ==========================================================================
  sl.registerFactory(() => ThemeCubit(prefs));
}
