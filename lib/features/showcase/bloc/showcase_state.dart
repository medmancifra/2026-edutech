part of 'showcase_bloc.dart';

enum ShowcaseStatus { initial, loading, success, failure }

class ShowcaseState extends Equatable {
  const ShowcaseState({
    this.status = ShowcaseStatus.initial,
    this.courses = const [],
    this.selectedCourseId,
    this.errorMessage,
  });

  final ShowcaseStatus status;
  final List<Course> courses;
  final String? selectedCourseId;
  final String? errorMessage;

  ShowcaseState copyWith({
    ShowcaseStatus? status,
    List<Course>? courses,
    String? selectedCourseId,
    String? errorMessage,
  }) {
    return ShowcaseState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      selectedCourseId: selectedCourseId ?? this.selectedCourseId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, courses, selectedCourseId, errorMessage];
}
