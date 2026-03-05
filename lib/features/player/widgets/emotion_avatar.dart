import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';

/// Displays a 2D animated avatar that reacts to emotion states.
///
/// In production this widget would drive a Rive StateMachine with the named
/// emotion input. For the demo we use emoji + colour-coded containers that
/// animate smoothly on emotion change.
///
/// Supported emotions (map to Rive state machine inputs in production):
///   excited, curious, happy, thinking, explaining, energetic,
///   celebrating, wise, proud, neutral
class EmotionAvatar extends StatelessWidget {
  const EmotionAvatar({
    super.key,
    required this.emotion,
    this.size = 180,
  });

  final String emotion;
  final double size;

  static const _emotionData = <String, _EmotionData>{
    'excited': _EmotionData(emoji: '🤩', primary: Color(0xFFF59E0B), label: 'Восторг'),
    'curious': _EmotionData(emoji: '🤔', primary: Color(0xFF6366F1), label: 'Любопытство'),
    'happy': _EmotionData(emoji: '😊', primary: Color(0xFF10B981), label: 'Радость'),
    'thinking': _EmotionData(emoji: '💭', primary: Color(0xFF8B5CF6), label: 'Размышление'),
    'explaining': _EmotionData(emoji: '📖', primary: Color(0xFF3B82F6), label: 'Объяснение'),
    'energetic': _EmotionData(emoji: '⚡', primary: Color(0xFFEF4444), label: 'Энергия'),
    'celebrating': _EmotionData(emoji: '🎉', primary: Color(0xFFF59E0B), label: 'Праздник'),
    'wise': _EmotionData(emoji: '🦉', primary: Color(0xFF0D9488), label: 'Мудрость'),
    'proud': _EmotionData(emoji: '💪', primary: Color(0xFF10B981), label: 'Гордость'),
    'neutral': _EmotionData(emoji: '🐍', primary: AppColors.primary, label: 'Пайтоша'),
  };

  @override
  Widget build(BuildContext context) {
    final data = _emotionData[emotion] ?? _emotionData['neutral']!;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: _AvatarBody(key: ValueKey(emotion), data: data, size: size),
    );
  }
}

class _AvatarBody extends StatelessWidget {
  const _AvatarBody({
    super.key,
    required this.data,
    required this.size,
  });

  final _EmotionData data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            data.primary.withOpacity(0.3),
            data.primary.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: data.primary.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing ring
          Container(
            width: size * 0.85,
            height: size * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: data.primary.withOpacity(0.2),
                width: 1.5,
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.05, 1.05),
                duration: 1200.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(1.05, 1.05),
                end: const Offset(0.95, 0.95),
                duration: 1200.ms,
                curve: Curves.easeInOut,
              ),

          // Emoji character
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.emoji,
                style: TextStyle(fontSize: size * 0.38),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(
                    begin: 0,
                    end: -8,
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: data.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  data.label,
                  style: TextStyle(
                    color: data.primary,
                    fontSize: size * 0.08,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmotionData {
  const _EmotionData({
    required this.emoji,
    required this.primary,
    required this.label,
  });

  final String emoji;
  final Color primary;
  final String label;
}
