import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get_it/get_it.dart';
import 'package:missionland_app/feature/auth/data/data_source_api/firebase_auth_api.dart';
import 'package:missionland_app/feature/auth/data/repository/firebase_auth_impl.dart';
import 'package:missionland_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:missionland_app/feature/auth/domain/usecases/is_signed_in_usaecase.dart';
import 'package:missionland_app/feature/auth/domain/usecases/sign_in_usecase.dart';
import 'package:missionland_app/feature/auth/domain/usecases/sign_out_usecase.dart';
import 'package:missionland_app/feature/auth/domain/usecases/sign_up_usecase.dart';
import 'package:missionland_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:missionland_app/feature/posts/data/datasource/image_upload_service.dart';
import 'package:missionland_app/feature/posts/data/datasource/post_remote_data_source.dart';
import 'package:missionland_app/feature/posts/data/repository/post_repository_impl.dart';
import 'package:missionland_app/feature/posts/domain/repository/post_repository.dart';
import 'package:missionland_app/feature/posts/domain/usecases/add_post_usecase.dart';
import 'package:missionland_app/feature/posts/domain/usecases/get_posts_usecase.dart';
import 'package:missionland_app/feature/posts/domain/usecases/toggle_like_usecase.dart';
import 'package:missionland_app/feature/posts/domain/usecases/toggle_thumbs_up_usecase.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<FirebaseAuthApi>(
    () => FirebaseAuthApi(auth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthImpl(firebaseAuthApi: sl<FirebaseAuthApi>()),
  );

  sl.registerLazySingleton<SignInUsecase>(
    () => SignInUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpUsecase>(
    () => SignUpUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOutUsecase>(
    () => SignOutUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<IsSignedInUsecase>(
    () => IsSignedInUsecase(authRepository: sl<AuthRepository>()),
  );

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      isSignedIn: sl<IsSignedInUsecase>(),
      signIn: sl<SignInUsecase>(),
      signUp: sl<SignUpUsecase>(),
      signOut: sl<SignOutUsecase>(),
    ),
  );

  sl.registerFactory<ImageUploadService>(() => ImageUploadService());
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(firestore: sl(), imageUploadService: sl()),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AddPostUseCase>(
    () => AddPostUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetPostsUseCase>(
    () => GetPostsUseCase(repository: sl()),
  );
  sl.registerLazySingleton<ToggleLikeUseCase>(
    () => ToggleLikeUseCase(repository: sl()),
  );
  sl.registerLazySingleton<ToggleThumbsUpUseCase>(
    () => ToggleThumbsUpUseCase(repository: sl()),
  );
  sl.registerFactory<PostBloc>(
    () => PostBloc(
      addPost: sl(),
      getPosts: sl(),
      toggleLike: sl(),
      toggleThumbsUp: sl(),
    ),
  );
}
