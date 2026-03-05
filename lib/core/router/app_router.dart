import 'package:flutter/material.dart';
import 'package:animalearn/features/auth/screens/registration_screen.dart';
import 'package:animalearn/features/showcase/screens/showcase_screen.dart';
import 'package:animalearn/features/player/screens/player_screen.dart';
import 'package:animalearn/features/review/screens/review_screen.dart';

/// MaterialRouter — Navigator 2.0 style routing using [Navigator] and
/// [MaterialPageRoute]. Replaces GoRouter (removed per issue #3).
///
/// Route names are defined as constants to avoid magic strings across the app.
class AppRoutes {
  static const registration = '/';
  static const showcase = '/showcase';
  static const player = '/player';
  static const review = '/review';
}

class AppRouter {
  /// Generates a [Route] for the given [RouteSettings].
  ///
  /// Used as [MaterialApp.onGenerateRoute].
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.registration:
        return _fade(const RegistrationScreen());

      case AppRoutes.showcase:
        return _slide(const ShowcaseScreen());

      case AppRoutes.player:
        final courseId = settings.arguments as String? ?? 'python-1h';
        return _slide(PlayerScreen(courseId: courseId));

      case AppRoutes.review:
        final courseId = settings.arguments as String? ?? 'python-1h';
        return _slide(ReviewScreen(courseId: courseId));

      default:
        return _fade(const RegistrationScreen());
    }
  }

  static PageRouteBuilder _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 380),
    );
  }
}
