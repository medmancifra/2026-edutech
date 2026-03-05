part of 'player_bloc.dart';

enum PlayerStatus {
  initial,
  loading,
  playing,
  paused,
  moduleComplete,
  courseComplete,
  failure,
}

class PlayerState extends Equatable {
  const PlayerState({
    this.status = PlayerStatus.initial,
    this.courseId,
    this.modules = const [],
    this.currentModuleIndex = 0,
    this.currentSegmentIndex = 0,
    this.segments = const [],
    this.currentEmotion = 'neutral',
    this.errorMessage,
  });

  final PlayerStatus status;
  final String? courseId;
  final List<CourseModule> modules;

  /// Index of the currently active module.
  final int currentModuleIndex;

  /// Index of the currently displayed segment within the module.
  final int currentSegmentIndex;

  /// Parsed segments for the current module.
  final List<ScriptSegment> segments;

  /// The most recently triggered emotion name (drives the animation).
  final String currentEmotion;

  final String? errorMessage;

  CourseModule? get currentModule =>
      modules.isNotEmpty ? modules[currentModuleIndex] : null;

  ScriptSegment? get currentSegment =>
      segments.isNotEmpty && currentSegmentIndex < segments.length
          ? segments[currentSegmentIndex]
          : null;

  bool get isLastSegment => currentSegmentIndex >= segments.length - 1;
  bool get isLastModule => currentModuleIndex >= modules.length - 1;

  double get moduleProgress =>
      segments.isEmpty ? 0 : (currentSegmentIndex + 1) / segments.length;

  PlayerState copyWith({
    PlayerStatus? status,
    String? courseId,
    List<CourseModule>? modules,
    int? currentModuleIndex,
    int? currentSegmentIndex,
    List<ScriptSegment>? segments,
    String? currentEmotion,
    String? errorMessage,
  }) {
    return PlayerState(
      status: status ?? this.status,
      courseId: courseId ?? this.courseId,
      modules: modules ?? this.modules,
      currentModuleIndex: currentModuleIndex ?? this.currentModuleIndex,
      currentSegmentIndex: currentSegmentIndex ?? this.currentSegmentIndex,
      segments: segments ?? this.segments,
      currentEmotion: currentEmotion ?? this.currentEmotion,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        courseId,
        modules,
        currentModuleIndex,
        currentSegmentIndex,
        segments,
        currentEmotion,
        errorMessage,
      ];
}
