import 'package:animalearn/features/review/bloc/review_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReviewBloc', () {
    test('initial state has rating 0 and canSubmit false', () {
      final bloc = ReviewBloc();
      expect(bloc.state.rating, 0);
      expect(bloc.state.canSubmit, false);
    });

    blocTest<ReviewBloc, ReviewState>(
      'emits updated rating when ReviewRatingChanged is added',
      build: () => ReviewBloc(),
      act: (bloc) => bloc.add(const ReviewRatingChanged(rating: 4.5)),
      expect: () => [
        isA<ReviewState>()
            .having((s) => s.rating, 'rating', 4.5)
            .having((s) => s.canSubmit, 'canSubmit', true),
      ],
    );

    blocTest<ReviewBloc, ReviewState>(
      'emits updated text when ReviewTextChanged is added',
      build: () => ReviewBloc(),
      act: (bloc) =>
          bloc.add(const ReviewTextChanged(text: 'Great course!')),
      expect: () => [
        isA<ReviewState>().having(
          (s) => s.reviewText,
          'reviewText',
          'Great course!',
        ),
      ],
    );

    blocTest<ReviewBloc, ReviewState>(
      'does not submit when rating is 0',
      build: () => ReviewBloc(),
      act: (bloc) =>
          bloc.add(const ReviewSubmitted(courseId: 'python-1h')),
      expect: () => [], // No state change
    );

    // Note: full submission test requires Supabase mock.
    // We test the canSubmit guard and state transitions here.
    blocTest<ReviewBloc, ReviewState>(
      'canSubmit becomes true only after rating is set',
      build: () => ReviewBloc(),
      act: (bloc) async {
        bloc.add(const ReviewRatingChanged(rating: 0)); // invalid
        bloc.add(const ReviewRatingChanged(rating: 3.0)); // valid
      },
      expect: () => [
        isA<ReviewState>()
            .having((s) => s.canSubmit, 'canSubmit', false),
        isA<ReviewState>()
            .having((s) => s.canSubmit, 'canSubmit', true),
      ],
    );
  });
}
