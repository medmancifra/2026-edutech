part of 'auth_bloc.dart';

enum AuthStatus { initial, generatingPassword, loading, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.generatedPassword,
    this.userId,
    this.errorMessage,
  });

  final AuthStatus status;

  /// Auto-generated password shown to the user before they tap Login.
  final String? generatedPassword;

  /// Supabase user ID on success.
  final String? userId;

  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    String? generatedPassword,
    String? userId,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      generatedPassword: generatedPassword ?? this.generatedPassword,
      userId: userId ?? this.userId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        generatedPassword,
        userId,
        errorMessage,
      ];
}
