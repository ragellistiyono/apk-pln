/// Comment events
library;

import 'package:equatable/equatable.dart';

/// Base class for comment events
abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load comments for a ticket
class CommentLoadRequested extends CommentEvent {
  final String ticketId;

  const CommentLoadRequested(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

/// Event to add a new comment
class CommentAddRequested extends CommentEvent {
  final String ticketId;
  final String text;

  const CommentAddRequested({
    required this.ticketId,
    required this.text,
  });

  @override
  List<Object?> get props => [ticketId, text];
}

/// Event to refresh comments
class CommentRefreshRequested extends CommentEvent {
  final String ticketId;

  const CommentRefreshRequested(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}