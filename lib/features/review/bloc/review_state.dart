part of 'review_bloc.dart';

enum ReviewStatus { initial, submitting, success, failure }

class ReviewState extends Equatable {
  const ReviewState({
    this.status = ReviewStatus.initial,
    this.rating = 0.0,
    this.reviewText = '',
    this.errorMessage,
  });

  final ReviewStatus status;
  final double rating;
  final String reviewText;
  final String? errorMessage;

  bool get canSubmit => rating > 0;

  ReviewState copyWith({
    ReviewStatus? status,
    double? rating,
    String? reviewText,
    String? errorMessage,
  }) {
    return ReviewState(
      status: status ?? this.status,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, rating, reviewText, errorMessage];
}
