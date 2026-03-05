part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

/// Load the course by ID and prepare the first module.
class PlayerLoadCourse extends PlayerEvent {
  const PlayerLoadCourse({required this.courseId});

  final String courseId;

  @override
  List<Object?> get props => [courseId];
}

/// User tapped play/pause.
class PlayerTogglePlayback extends PlayerEvent {
  const PlayerTogglePlayback();
}

/// Advance to the next segment in the current module.
class PlayerAdvanceSegment extends PlayerEvent {
  const PlayerAdvanceSegment();
}

/// Navigate to a specific module index.
class PlayerGoToModule extends PlayerEvent {
  const PlayerGoToModule({required this.moduleIndex});

  final int moduleIndex;

  @override
  List<Object?> get props => [moduleIndex];
}

/// User finished the last module — ready to review.
class PlayerCourseCompleted extends PlayerEvent {
  const PlayerCourseCompleted();
}
