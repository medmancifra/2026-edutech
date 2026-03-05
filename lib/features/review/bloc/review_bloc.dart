import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'review_event.dart';
part 'review_state.dart';

final _log = Logger(printer: PrettyPrinter(methodCount: 0));

/// BLoC for the end-of-course review screen.
///
/// Submits the rating + text to Supabase via the `reviews` Edge Function.
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(const ReviewState()) {
    on<ReviewRatingChanged>(_onRatingChanged);
    on<ReviewTextChanged>(_onTextChanged);
    on<ReviewSubmitted>(_onSubmitted);
  }

  void _onRatingChanged(
    ReviewRatingChanged event,
    Emitter<ReviewState> emit,
  ) {
    emit(state.copyWith(rating: event.rating));
  }

  void _onTextChanged(
    ReviewTextChanged event,
    Emitter<ReviewState> emit,
  ) {
    emit(state.copyWith(reviewText: event.text));
  }

  Future<void> _onSubmitted(
    ReviewSubmitted event,
    Emitter<ReviewState> emit,
  ) async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: ReviewStatus.submitting));

    try {
      // Call the Supabase Edge Function `reviews`.
      // In demo mode this is a best-effort call — failures are silently caught.
      await Supabase.instance.client.functions.invoke(
        'reviews',
        body: {
          'course_id': event.courseId,
          'rating': state.rating,
          'text': state.reviewText.trim(),
        },
      );
      _log.i(
        'Review submitted — course: ${event.courseId}, '
        'rating: ${state.rating}',
      );
    } catch (e) {
      // Log but don't block the user in demo mode
      _log.w('Review submission failed (demo mode): $e');
    }

    emit(state.copyWith(status: ReviewStatus.success));
  }
}
