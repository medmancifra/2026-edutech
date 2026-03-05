part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class ReviewRatingChanged extends ReviewEvent {
  const ReviewRatingChanged({required this.rating});

  final double rating;

  @override
  List<Object?> get props => [rating];
}

class ReviewTextChanged extends ReviewEvent {
  const ReviewTextChanged({required this.text});

  final String text;

  @override
  List<Object?> get props => [text];
}

class ReviewSubmitted extends ReviewEvent {
  const ReviewSubmitted({required this.courseId});

  final String courseId;

  @override
  List<Object?> get props => [courseId];
}
