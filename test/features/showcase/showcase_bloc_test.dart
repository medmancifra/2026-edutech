import 'package:animalearn/features/showcase/bloc/showcase_bloc.dart';
import 'package:animalearn/features/showcase/models/course.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShowcaseBloc', () {
    test('initial state is ShowcaseStatus.initial', () {
      final bloc = ShowcaseBloc();
      expect(bloc.state.status, ShowcaseStatus.initial);
      expect(bloc.state.courses, isEmpty);
    });

    blocTest<ShowcaseBloc, ShowcaseState>(
      'emits loading then success with demo course after ShowcaseLoadCourses',
      build: () => ShowcaseBloc(),
      act: (bloc) => bloc.add(const ShowcaseLoadCourses()),
      wait: const Duration(seconds: 1),
      expect: () => [
        isA<ShowcaseState>()
            .having((s) => s.status, 'status', ShowcaseStatus.loading),
        isA<ShowcaseState>()
            .having((s) => s.status, 'status', ShowcaseStatus.success)
            .having((s) => s.courses, 'courses', isNotEmpty)
            .having(
              (s) => s.courses.first.id,
              'first course id',
              'python-1h',
            ),
      ],
    );

    blocTest<ShowcaseBloc, ShowcaseState>(
      'updates selectedCourseId when ShowcaseCourseSelected is added',
      build: () => ShowcaseBloc(),
      act: (bloc) =>
          bloc.add(const ShowcaseCourseSelected(courseId: 'python-1h')),
      expect: () => [
        isA<ShowcaseState>().having(
          (s) => s.selectedCourseId,
          'selectedCourseId',
          'python-1h',
        ),
      ],
    );

    test('demo course has 6 modules', () {
      expect(Course.demoModules, hasLength(6));
    });

    test('demo course modules all have non-empty emotion scripts', () {
      for (final module in Course.demoModules) {
        expect(module.emotionScript, isNotEmpty,
            reason: 'Module "${module.title}" has empty emotionScript');
      }
    });
  });
}
