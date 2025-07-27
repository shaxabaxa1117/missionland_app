part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInEvent({required this.email, required this.password});
}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthSignUpEvent({required this.email, required this.password});
}

class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}

class AuthCheckEvent extends AuthEvent {
  const AuthCheckEvent();
}

