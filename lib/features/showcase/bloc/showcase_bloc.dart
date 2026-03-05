import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/course.dart';

part 'showcase_event.dart';
part 'showcase_state.dart';

/// BLoC for the Showcase (course listing) screen.
///
/// In production this would fetch courses from the Supabase `courses` Edge
/// Function. For the demo we load the seed data immediately.
class ShowcaseBloc extends Bloc<ShowcaseEvent, ShowcaseState> {
  ShowcaseBloc() : super(const ShowcaseState()) {
    on<ShowcaseLoadCourses>(_onLoadCourses);
    on<ShowcaseCourseSelected>(_onCourseSelected);
  }

  Future<void> _onLoadCourses(
    ShowcaseLoadCourses event,
    Emitter<ShowcaseState> emit,
  ) async {
    emit(state.copyWith(status: ShowcaseStatus.loading));

    // Simulate a brief network delay for visual feedback
    await Future<void>.delayed(const Duration(milliseconds: 600));

    emit(state.copyWith(
      status: ShowcaseStatus.success,
      courses: [Course.demoCourse],
    ));
  }

  void _onCourseSelected(
    ShowcaseCourseSelected event,
    Emitter<ShowcaseState> emit,
  ) {
    emit(state.copyWith(selectedCourseId: event.courseId));
  }
}
