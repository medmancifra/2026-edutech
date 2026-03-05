import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC for the fast-registration / login flow.
///
/// Flow:
///   1. Screen loads → bloc generates a password and emits [AuthStatus.generatingPassword]
///      with the [AuthState.generatedPassword] filled in so the UI can display it.
///   2. User taps "Login" → [AuthLoginRequested] is dispatched.
///   3. Bloc calls [AuthRepository.register] (or sign-in if already exists).
///   4. On success → [AuthStatus.success] with [AuthState.userId].
///   5. On failure → [AuthStatus.failure] with [AuthState.errorMessage].
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repository}) : super(const AuthState()) {
    on<AuthPasswordGenerated>(_onPasswordGenerated);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthReset>(_onReset);
  }

  final AuthRepository repository;

  void _onPasswordGenerated(
    AuthPasswordGenerated event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      status: AuthStatus.generatingPassword,
      generatedPassword: event.password,
    ));
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final password = state.generatedPassword;
    if (password == null || password.isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: 'Password not generated yet.',
      ));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      // Try register first; if the user already exists, sign in.
      final user = await repository.register(
        email: event.email,
        password: password,
      );
      emit(state.copyWith(
        status: AuthStatus.success,
        userId: user.id,
      ));
    } catch (e) {
      // Fall back to sign-in (demo: same auto-password)
      try {
        final user = await repository.signIn(
          email: event.email,
          password: password,
        );
        emit(state.copyWith(
          status: AuthStatus.success,
          userId: user.id,
        ));
      } catch (signInError) {
        emit(state.copyWith(
          status: AuthStatus.failure,
          errorMessage: signInError.toString(),
        ));
      }
    }
  }

  void _onReset(AuthReset event, Emitter<AuthState> emit) {
    emit(const AuthState());
  }
}
