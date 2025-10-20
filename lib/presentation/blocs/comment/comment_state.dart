/// Comment states
library;

import 'package:equatable/equatable.dart';
import '../../../data/models/comment_model.dart';

/// Base class for comment states
abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CommentInitial extends CommentState {
  const CommentInitial();
}

/// Loading comments
class CommentLoading extends CommentState {
  const CommentLoading();
}

/// Comments loaded successfully
class CommentLoaded extends CommentState {
  final List<CommentModel> comments;
  final int total;
  final String ticketId;

  const CommentLoaded({
    required this.comments,
    required this.total,
    required this.ticketId,
  });

  @override
  List<Object?> get props => [comments, total, ticketId];

  CommentLoaded copyWith({
    List<CommentModel>? comments,
    int? total,
    String? ticketId,
  }) {
    return CommentLoaded(
      comments: comments ?? this.comments,
      total: total ?? this.total,
      ticketId: ticketId ?? this.ticketId,
    );
  }
}

/// Adding a comment
class CommentAdding extends CommentState {
  const CommentAdding();
}

/// Comment added successfully
class CommentAdded extends CommentState {
  final CommentModel comment;

  const CommentAdded(this.comment);

  @override
  List<Object?> get props => [comment];
}

/// Error state
class CommentError extends CommentState {
  final String message;

  const CommentError(this.message);

  @override
  List<Object?> get props => [message];
}