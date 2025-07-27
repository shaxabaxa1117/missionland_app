
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


final sl = GetIt.instance;

Future<void> initializeDependecies() async {
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<FirebaseAuthApi>(
    () => FirebaseAuthApi(
      auth: sl<FirebaseAuth>(),

    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthImpl(firebaseAuthApi: sl<FirebaseAuthApi>()),
  );
  //! sl.registerLazySingleton<AuthRepository> because FirebaseAuthImpl implements AuthRepository

  //!------------------------------------------------------!//
  //!                      Usecases                         //
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


  //!------------------------------------------------------!//

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      isSignedIn: sl<IsSignedInUsecase>(),
      signIn: sl<SignInUsecase>(),
      signUp: sl<SignUpUsecase>(),
      signOut: sl<SignOutUsecase>(),

    ),
  );
}
