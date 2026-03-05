import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../showcase/models/course.dart';
import '../models/emotion_script_parser.dart';

part 'player_event.dart';
part 'player_state.dart';

/// BLoC for the course player.
///
/// Controls:
///   • Loading and parsing the emotion-script for each module.
///   • Stepping through [ScriptSegment]s one by one.
///   • Emitting the current emotion to drive the animation canvas.
///   • Tracking module / course completion.
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(const PlayerState()) {
    on<PlayerLoadCourse>(_onLoadCourse);
    on<PlayerTogglePlayback>(_onTogglePlayback);
    on<PlayerAdvanceSegment>(_onAdvanceSegment);
    on<PlayerGoToModule>(_onGoToModule);
    on<PlayerCourseCompleted>(_onCourseCompleted);
  }

  Future<void> _onLoadCourse(
    PlayerLoadCourse event,
    Emitter<PlayerState> emit,
  ) async {
    emit(state.copyWith(status: PlayerStatus.loading));

    // In production: fetch from Supabase. For demo use seed data.
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final modules = Course.demoModules;
    final segments = EmotionScriptParser.parse(modules.first.emotionScript);

    emit(state.copyWith(
      status: PlayerStatus.playing,
      courseId: event.courseId,
      modules: modules,
      currentModuleIndex: 0,
      currentSegmentIndex: 0,
      segments: segments,
      currentEmotion: _extractFirstEmotion(segments),
    ));
  }

  void _onTogglePlayback(
    PlayerTogglePlayback event,
    Emitter<PlayerState> emit,
  ) {
    final newStatus = state.status == PlayerStatus.playing
        ? PlayerStatus.paused
        : PlayerStatus.playing;
    emit(state.copyWith(status: newStatus));
  }

  void _onAdvanceSegment(
    PlayerAdvanceSegment event,
    Emitter<PlayerState> emit,
  ) {
    if (state.status == PlayerStatus.moduleComplete ||
        state.status == PlayerStatus.courseComplete) {
      return;
    }

    final nextIndex = state.currentSegmentIndex + 1;

    if (nextIndex >= state.segments.length) {
      // Module finished
      if (state.isLastModule) {
        emit(state.copyWith(status: PlayerStatus.courseComplete));
      } else {
        emit(state.copyWith(status: PlayerStatus.moduleComplete));
      }
      return;
    }

    final nextSegment = state.segments[nextIndex];
    final emotion = nextSegment is EmotionSegment
        ? nextSegment.emotion
        : state.currentEmotion;

    emit(state.copyWith(
      currentSegmentIndex: nextIndex,
      currentEmotion: emotion,
      status: PlayerStatus.playing,
    ));
  }

  void _onGoToModule(
    PlayerGoToModule event,
    Emitter<PlayerState> emit,
  ) {
    if (event.moduleIndex < 0 ||
        event.moduleIndex >= state.modules.length) {
      return;
    }

    final module = state.modules[event.moduleIndex];
    final segments = EmotionScriptParser.parse(module.emotionScript);

    emit(state.copyWith(
      status: PlayerStatus.playing,
      currentModuleIndex: event.moduleIndex,
      currentSegmentIndex: 0,
      segments: segments,
      currentEmotion: _extractFirstEmotion(segments),
    ));
  }

  void _onCourseCompleted(
    PlayerCourseCompleted event,
    Emitter<PlayerState> emit,
  ) {
    emit(state.copyWith(status: PlayerStatus.courseComplete));
  }

  String _extractFirstEmotion(List<ScriptSegment> segments) {
    for (final seg in segments) {
      if (seg is EmotionSegment) return seg.emotion;
    }
    return 'neutral';
  }
}
