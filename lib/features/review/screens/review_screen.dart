import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/review_bloc.dart';

/// End-of-course review screen.
///
/// Demo user journey step 4:
///   • Star rating (1-5) using [RatingBar].
///   • Optional text review field.
///   • "Submit" button → saves via [ReviewBloc] to Supabase Edge Function.
///   • After success → back to [ShowcaseScreen].
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReviewBloc(),
      child: _ReviewView(courseId: courseId),
    );
  }
}

class _ReviewView extends StatefulWidget {
  const _ReviewView({required this.courseId});

  final String courseId;

  @override
  State<_ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<_ReviewView> {
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оценить курс'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state.status == ReviewStatus.success) {
            // Show success snackbar then go back to showcase
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Отзыв отправлен! Спасибо 🙏'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.showcase,
                  (route) => false,
                );
              }
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),

                // Celebration header
                _CompletionHeader()
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1)),
                const SizedBox(height: 40),

                // Rating section
                _RatingSection(currentRating: state.rating)
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 32),

                // Review text
                _ReviewTextField(controller: _reviewController)
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 32),

                // Submit button
                _SubmitButton(
                  state: state,
                  courseId: widget.courseId,
                  reviewController: _reviewController,
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 16),

                // Skip link
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          AppRoutes.showcase, (route) => false),
                  child: const Text(
                    'Пропустить',
                    style: TextStyle(color: AppColors.onSurfaceMuted),
                  ),
                ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CompletionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Text('🎓', style: TextStyle(fontSize: 50)),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.05, 1.05),
              duration: 1200.ms,
              curve: Curves.easeInOut,
            ),
        const SizedBox(height: 20),
        Text(
          'Курс пройден!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Вы прошли "Выучи Python за 1 час".\nРасскажите, как это было!',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _RatingSection extends StatelessWidget {
  const _RatingSection({required this.currentRating});

  final double currentRating;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Ваша оценка курса',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        RatingBar.builder(
          initialRating: currentRating,
          minRating: 1,
          maxRating: 5,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 48,
          glow: true,
          glowColor: AppColors.starColor.withOpacity(0.3),
          unratedColor: AppColors.surfaceVariant,
          itemBuilder: (context, _) => const Icon(
            Icons.star_rounded,
            color: AppColors.starColor,
          ),
          onRatingUpdate: (rating) => context
              .read<ReviewBloc>()
              .add(ReviewRatingChanged(rating: rating)),
        ),
        const SizedBox(height: 12),
        if (currentRating > 0)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: ValueKey(currentRating),
              _ratingLabel(currentRating),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.starColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
      ],
    );
  }

  String _ratingLabel(double rating) {
    if (rating >= 4.5) return '⭐ Отлично!';
    if (rating >= 3.5) return '👍 Хорошо';
    if (rating >= 2.5) return '😐 Нормально';
    if (rating >= 1.5) return '👎 Плохо';
    return '😞 Очень плохо';
  }
}

class _ReviewTextField extends StatelessWidget {
  const _ReviewTextField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Напишите отзыв (необязательно)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          maxLines: 4,
          maxLength: 500,
          onChanged: (text) => context
              .read<ReviewBloc>()
              .add(ReviewTextChanged(text: text)),
          decoration: InputDecoration(
            hintText:
                'Что вам понравилось? Что можно улучшить?',
            hintStyle:
                const TextStyle(color: AppColors.onSurfaceMuted, fontSize: 14),
            counterStyle:
                const TextStyle(color: AppColors.onSurfaceMuted, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.state,
    required this.courseId,
    required this.reviewController,
  });

  final ReviewState state;
  final String courseId;
  final TextEditingController reviewController;

  @override
  Widget build(BuildContext context) {
    final isLoading = state.status == ReviewStatus.submitting;

    return ElevatedButton(
      onPressed: !state.canSubmit || isLoading
          ? null
          : () => context
              .read<ReviewBloc>()
              .add(ReviewSubmitted(courseId: courseId)),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            state.canSubmit ? AppColors.primary : AppColors.surfaceVariant,
      ),
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: Colors.white),
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, size: 18),
                SizedBox(width: 10),
                Text('Отправить отзыв'),
              ],
            ),
    );
  }
}
