part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// User typed an email and tapped "Login" — triggers auto-register + sign-in.
class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

/// Used to pre-fill the generated password field.
class AuthPasswordGenerated extends AuthEvent {
  const AuthPasswordGenerated({required this.password});

  final String password;

  @override
  List<Object?> get props => [password];
}

/// Reset to initial state (e.g. sign-out).
class AuthReset extends AuthEvent {
  const AuthReset();
}
