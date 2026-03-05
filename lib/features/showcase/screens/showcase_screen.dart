import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/showcase_bloc.dart';
import '../widgets/course_card.dart';

/// Showcase (course catalog) screen.
///
/// Demo user journey step 2:
///   • Displays a course card for "Выучи Python за 1 час".
///   • Tapping the card navigates to [PlayerScreen].
class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Витрина курсов'),
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.auto_stories, color: AppColors.primary, size: 28),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {},
            tooltip: 'Поиск',
          ),
        ],
      ),
      body: BlocBuilder<ShowcaseBloc, ShowcaseState>(
        builder: (context, state) {
          return switch (state.status) {
            ShowcaseStatus.initial ||
            ShowcaseStatus.loading =>
              const _LoadingContent(),
            ShowcaseStatus.failure => _ErrorContent(
                message: state.errorMessage ?? 'Ошибка загрузки курсов',
              ),
            ShowcaseStatus.success => _CourseList(state: state),
          };
        },
      ),
    );
  }
}

class _CourseList extends StatelessWidget {
  const _CourseList({required this.state});

  final ShowcaseState state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero banner
        SliverToBoxAdapter(
          child: _HeroBanner().animate().fadeIn(duration: 600.ms),
        ),

        // Section header
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Популярные курсы',
                  style: Theme.of(context).textTheme.titleLarge,
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
                Text(
                  '${state.courses.length} курсов',
                  style: Theme.of(context).textTheme.bodyMedium,
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              ],
            ),
          ),
        ),

        // Course cards
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.separated(
            itemCount: state.courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final course = state.courses[index];
              return CourseCard(
                course: course,
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.player,
                  arguments: course.id,
                ),
              );
            },
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -10,
            top: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🎯  Учись через анимацию',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Emotion-scripts делают\nобучение незабываемым',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Смотреть всё →',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceVariant,
        child: Container(
          height: 360,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 56, color: AppColors.error),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context
                .read<ShowcaseBloc>()
                .add(const ShowcaseLoadCourses()),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}
