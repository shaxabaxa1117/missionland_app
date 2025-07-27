
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:missionland_app/feature/auth/domain/usecases/is_signed_in_usaecase.dart';
import 'package:missionland_app/feature/auth/domain/usecases/sign_in_usecase.dart';
import 'package:missionland_app/feature/auth/domain/usecases/sign_out_usecase.dart';
import 'package:missionland_app/feature/auth/domain/usecases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUsecase signIn;
  final SignUpUsecase signUp;
  final SignOutUsecase signOut;
  final IsSignedInUsecase isSignedIn;


  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.isSignedIn,

  }) : super(AuthInitial()) {
    //!---------------------------------!//
    on<AuthCheckEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        if (await isSignedIn() == true) {
          print("User is signed in");
          emit(Authenticated());
        } else {
          print("User is not signed in");
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    //!---------------------------------!//
    on<AuthSignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await signIn(event.email, event.password);
        emit(Authenticated());
      } catch (e) {
        print('error');
        emit(AuthError(message: e.toString()));
      }
    });

    //!---------------------------------!//
    on<AuthSignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await signUp(event.email, event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    //!---------------------------------!//
    on<AuthSignOutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await signOut();
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    //!---------------------------------!//






  }
}
