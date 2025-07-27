part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class  Authenticated extends AuthState{}

final class Unauthenticated extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
  
  @override
  List<Object> get props => [message];
}
final class ResetPasswordError extends AuthState {
  final String message;
  const ResetPasswordError({required this.message});
  
  @override
  List<Object> get props => [message];
}

final class ResetPasswordSuccess extends AuthState {
  final String message;
  const ResetPasswordSuccess({required this.message});
  
  @override
  List<Object> get props => [message];
}


final class EmailVerificationSent extends AuthState {}

final class EmailNotVerified extends AuthState {}