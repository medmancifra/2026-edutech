import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final _log = Logger(printer: PrettyPrinter(methodCount: 0));

/// Handles authentication operations via Supabase Auth.
///
/// For the demo the "fast registration" flow:
///   1. User provides only their email.
///   2. A random password is auto-generated and returned to the UI so the user
///      can see it before logging in.
///   3. If the email already exists we fall back to sign-in with the same
///      auto-generated password (not realistic for production — demo only).
class AuthRepository {
  const AuthRepository();

  final _supabase = Supabase.instance.client;

  /// Generates a short, human-readable random password.
  String generatePassword() {
    final id = const Uuid().v4().replaceAll('-', '');
    // Take first 10 chars and capitalise first letter for readability
    final raw = id.substring(0, 10);
    return '${raw[0].toUpperCase()}${raw.substring(1)}!';
  }

  /// Register with [email] and [password].
  ///
  /// Returns the signed-in [User] on success.
  /// Throws a [AuthException] or generic [Exception] on failure.
  Future<User> register({
    required String email,
    required String password,
  }) async {
    _log.d('Registering user: $email');
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) {
      throw Exception('Registration failed: no user returned');
    }
    _log.i('Registered user: ${user.id}');
    return user;
  }

  /// Sign in with [email] and [password].
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    _log.d('Signing in: $email');
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) {
      throw Exception('Sign-in failed: no user returned');
    }
    _log.i('Signed in: ${user.id}');
    return user;
  }

  /// Returns the currently authenticated user, or null.
  User? get currentUser => _supabase.auth.currentUser;
}
