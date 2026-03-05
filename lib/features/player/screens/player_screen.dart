import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../showcase/models/course.dart';
import '../bloc/player_bloc.dart';
import '../models/emotion_script_parser.dart';
import '../widgets/emotion_avatar.dart';

/// Course player screen.
///
/// Demo user journey step 3:
///   • Loads the "Learn Python in 1 Hour" modules.
///   • Displays the animated EmotionAvatar that reacts to [EmotionSegment]s.
///   • Shows narration text and syntax-highlighted code blocks.
///   • "Next" button advances through script segments.
///   • On last module completion → navigates to [ReviewScreen].
class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayerBloc()..add(PlayerLoadCourse(courseId: courseId)),
      child: _PlayerView(courseId: courseId),
    );
  }
}

class _PlayerView extends StatelessWidget {
  const _PlayerView({required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayerBloc, PlayerState>(
      listener: (context, state) {
        if (state.status == PlayerStatus.courseComplete) {
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.review,
            arguments: courseId,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _PlayerAppBar(state: state),
          body: switch (state.status) {
            PlayerStatus.initial || PlayerStatus.loading => const _LoadingView(),
            PlayerStatus.failure => _ErrorView(
                message: state.errorMessage ?? 'Ошибка загрузки курса',
              ),
            _ => _ActivePlayer(state: state),
          },
        );
      },
    );
  }
}

class _PlayerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PlayerAppBar({required this.state});

  final PlayerState state;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        state.currentModule?.title ?? 'Загрузка...',
        style: const TextStyle(fontSize: 16),
      ),
      bottom: state.modules.isNotEmpty
          ? PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: LinearProgressIndicator(
                value: state.moduleProgress,
                backgroundColor: AppColors.surfaceVariant,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 4,
              ),
            )
          : null,
      actions: [
        // Module counter
        if (state.modules.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${state.currentModuleIndex + 1}/${state.modules.length}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActivePlayer extends StatelessWidget {
  const _ActivePlayer({required this.state});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    final segment = state.currentSegment;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animation canvas — EmotionAvatar
                EmotionAvatar(emotion: state.currentEmotion),
                const SizedBox(height: 32),

                // Current segment content
                if (segment != null) _SegmentDisplay(segment: segment),

                const SizedBox(height: 24),

                // Module progress indicator
                _ModuleList(state: state),
              ],
            ),
          ),
        ),

        // Bottom controls
        _PlayerControls(state: state),
      ],
    );
  }
}

class _SegmentDisplay extends StatelessWidget {
  const _SegmentDisplay({required this.segment});

  final ScriptSegment segment;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: switch (segment) {
        EmotionSegment() => const SizedBox.shrink(),
        NarrationSegment(:final text) => _NarrationCard(text: text),
        CodeSegment(:final language, :final code) =>
          _CodeCard(language: language, code: code),
      },
    );
  }
}

class _NarrationCard extends StatelessWidget {
  const _NarrationCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(text),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontSize: 17,
            ),
        textAlign: TextAlign.center,
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.language, required this.code});

  final String language;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(code),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withOpacity(0.5),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFF5F57),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFBD2E),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF28CA41),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  language,
                  style: const TextStyle(
                    color: AppColors.onSurfaceMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Code body
          Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Color(0xFFCDD6F4),
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }
}

class _ModuleList extends StatelessWidget {
  const _ModuleList({required this.state});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Модули курса',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceMuted,
              ),
        ),
        const SizedBox(height: 8),
        ...state.modules.asMap().entries.map((entry) {
          final i = entry.key;
          final module = entry.value;
          final isActive = i == state.currentModuleIndex;
          final isDone = i < state.currentModuleIndex;

          return GestureDetector(
            onTap: () => context
                .read<PlayerBloc>()
                .add(PlayerGoToModule(moduleIndex: i)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? AppColors.primary.withOpacity(0.5)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isDone
                        ? Icons.check_circle
                        : isActive
                            ? Icons.play_circle_filled
                            : Icons.radio_button_unchecked,
                    size: 18,
                    color: isDone
                        ? AppColors.success
                        : isActive
                            ? AppColors.primary
                            : AppColors.onSurfaceMuted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${i + 1}. ${module.title}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isActive
                                ? AppColors.onSurface
                                : AppColors.onSurfaceMuted,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                    ),
                  ),
                  Text(
                    '${module.durationMinutes} мин',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _PlayerControls extends StatelessWidget {
  const _PlayerControls({required this.state});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    final isModuleComplete = state.status == PlayerStatus.moduleComplete;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.surfaceVariant, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Play/Pause
          IconButton(
            onPressed: () => bloc.add(const PlayerTogglePlayback()),
            icon: Icon(
              state.status == PlayerStatus.playing
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              size: 44,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),

          // Next segment / Next module / Finish
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (isModuleComplete) {
                  final nextIndex = state.currentModuleIndex + 1;
                  if (nextIndex < state.modules.length) {
                    bloc.add(PlayerGoToModule(moduleIndex: nextIndex));
                  } else {
                    bloc.add(const PlayerCourseCompleted());
                  }
                } else {
                  bloc.add(const PlayerAdvanceSegment());
                }
              },
              child: Text(
                isModuleComplete
                    ? (state.isLastModule
                        ? '🎉 Завершить курс'
                        : '➡ Следующий модуль')
                    : (state.isLastSegment
                        ? '✅ Завершить урок'
                        : 'Далее →'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 20),
          Text(
            'Загружаем курс...',
            style: TextStyle(color: AppColors.onSurfaceMuted),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Назад'),
          ),
        ],
      ),
    );
  }
}
