part of 'showcase_bloc.dart';

abstract class ShowcaseEvent extends Equatable {
  const ShowcaseEvent();

  @override
  List<Object?> get props => [];
}

class ShowcaseLoadCourses extends ShowcaseEvent {
  const ShowcaseLoadCourses();
}

class ShowcaseCourseSelected extends ShowcaseEvent {
  const ShowcaseCourseSelected({required this.courseId});

  final String courseId;

  @override
  List<Object?> get props => [courseId];
}
