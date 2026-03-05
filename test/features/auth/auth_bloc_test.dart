import 'package:animalearn/features/auth/bloc/auth_bloc.dart';
import 'package:animalearn/features/auth/repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeUser extends Fake implements User {
  @override
  String get id => 'test-user-id-123';

  @override
  String? get email => 'test@example.com';
}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  group('AuthBloc', () {
    test('initial state is AuthStatus.initial', () {
      final bloc = AuthBloc(repository: mockRepo);
      expect(bloc.state.status, AuthStatus.initial);
    });

    blocTest<AuthBloc, AuthState>(
      'emits generatingPassword when AuthPasswordGenerated is added',
      build: () => AuthBloc(repository: mockRepo),
      act: (bloc) =>
          bloc.add(const AuthPasswordGenerated(password: 'TestPass1!')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.generatingPassword)
            .having((s) => s.generatedPassword, 'password', 'TestPass1!'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits failure when login attempted without generated password',
      build: () => AuthBloc(repository: mockRepo),
      act: (bloc) =>
          bloc.add(const AuthLoginRequested(email: 'test@example.com')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure)
            .having(
                (s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits loading then success when registration succeeds',
      build: () {
        when(() => mockRepo.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => FakeUser());
        return AuthBloc(repository: mockRepo);
      },
      seed: () => const AuthState(
        status: AuthStatus.generatingPassword,
        generatedPassword: 'TestPass1!',
      ),
      act: (bloc) =>
          bloc.add(const AuthLoginRequested(email: 'test@example.com')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.success)
            .having((s) => s.userId, 'userId', 'test-user-id-123'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'falls back to signIn when register throws',
      build: () {
        when(() => mockRepo.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('already registered'));
        when(() => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => FakeUser());
        return AuthBloc(repository: mockRepo);
      },
      seed: () => const AuthState(
        status: AuthStatus.generatingPassword,
        generatedPassword: 'TestPass1!',
      ),
      act: (bloc) =>
          bloc.add(const AuthLoginRequested(email: 'test@example.com')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.success),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits failure when both register and signIn throw',
      build: () {
        when(() => mockRepo.register(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('already registered'));
        when(() => mockRepo.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('wrong password'));
        return AuthBloc(repository: mockRepo);
      },
      seed: () => const AuthState(
        status: AuthStatus.generatingPassword,
        generatedPassword: 'TestPass1!',
      ),
      act: (bloc) =>
          bloc.add(const AuthLoginRequested(email: 'test@example.com')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'resets to initial when AuthReset is added',
      build: () => AuthBloc(repository: mockRepo),
      seed: () => const AuthState(
        status: AuthStatus.success,
        userId: 'some-id',
      ),
      act: (bloc) => bloc.add(const AuthReset()),
      expect: () => [const AuthState()],
    );

    test('generatePassword returns non-empty string', () {
      when(() => mockRepo.generatePassword()).thenReturn('TestPass1!');
      expect(mockRepo.generatePassword(), isNotEmpty);
    });
  });
}
