import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/auth_bloc.dart';

/// Fast-registration screen.
///
/// Demo user journey step 1:
///   • Single email input field.
///   • Password is auto-generated and shown in a read-only field.
///   • "Login" button triggers registration + sign-in via [AuthBloc].
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Generate password immediately when the screen opens
    final password =
        context.read<AuthBloc>().repository.generatePassword();
    context.read<AuthBloc>().add(AuthPasswordGenerated(password: password));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthLoginRequested(email: _emailController.text.trim()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.showcase);
          } else if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication failed'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Logo / Brand
                    _BrandHeader()
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 48),

                    // Headline
                    Text(
                      'Начать обучение',
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms)
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      'Введите email — мы всё остальное сделаем за вас',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 500.ms),
                    const SizedBox(height: 36),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.onSurfaceMuted,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Введите email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value.trim())) {
                          return 'Некорректный email';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 500.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 20),

                    // Auto-generated password field (read-only)
                    _PasswordField(
                      password: state.generatedPassword,
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 500.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Пароль сгенерирован автоматически',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                  ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                    const SizedBox(height: 40),

                    // Login button
                    _LoginButton(
                      isLoading: state.status == AuthStatus.loading,
                      onPressed: _onLogin,
                    )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 500.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.auto_stories, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AnimaLearn',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              'Учись через анимацию',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({required this.password});

  final String? password;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _copied = false;

  void _copy() {
    if (widget.password == null) return;
    Clipboard.setData(ClipboardData(text: widget.password!));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      initialValue: widget.password ?? '...',
      obscureText: false,
      style: const TextStyle(
        fontFamily: 'monospace',
        color: AppColors.secondary,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Пароль (автоматический)',
        prefixIcon: const Icon(
          Icons.lock_outlined,
          color: AppColors.onSurfaceMuted,
        ),
        suffixIcon: IconButton(
          onPressed: _copy,
          icon: Icon(
            _copied ? Icons.check : Icons.copy,
            color: _copied ? AppColors.success : AppColors.onSurfaceMuted,
            size: 20,
          ),
          tooltip: 'Скопировать пароль',
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rocket_launch_outlined, size: 20),
                SizedBox(width: 10),
                Text('Войти и начать'),
              ],
            ),
    );
  }
}
