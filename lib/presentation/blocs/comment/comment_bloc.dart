/// Comment BLoC for managing comment state
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../domain/usecases/comments/add_comment_usecase.dart';
import '../../../domain/usecases/comments/get_comments_usecase.dart';
import 'comment_event.dart';
import 'comment_state.dart';

/// BLoC for handling comment operations
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final AddCommentUseCase _addCommentUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final Logger _logger = Logger();

  CommentBloc(
    this._addCommentUseCase,
    this._getCommentsUseCase,
  ) : super(const CommentInitial()) {
    on<CommentLoadRequested>(_onCommentLoadRequested);
    on<CommentAddRequested>(_onCommentAddRequested);
    on<CommentRefreshRequested>(_onCommentRefreshRequested);
  }

  /// Handle load comments request
  Future<void> _onCommentLoadRequested(
    CommentLoadRequested event,
    Emitter<CommentState> emit,
  ) async {
    emit(const CommentLoading());

    try {
      _logger.d('Loading comments for ticket: ${event.ticketId}');

      final response = await _getCommentsUseCase.execute(event.ticketId);

      _logger.i('Loaded ${response.comments.length} comments');

      emit(CommentLoaded(
        comments: response.comments,
        total: response.total,
        ticketId: event.ticketId,
      ));
    } catch (e) {
      _logger.e('Failed to load comments: $e');
      emit(CommentError(e.toString()));
    }
  }

  /// Handle add comment request
  Future<void> _onCommentAddRequested(
    CommentAddRequested event,
    Emitter<CommentState> emit,
  ) async {
    // Keep current state while adding
    final currentState = state;
    emit(const CommentAdding());

    try {
      _logger.d('Adding comment to ticket: ${event.ticketId}');

      final comment = await _addCommentUseCase.execute(
        event.ticketId,
        event.text,
      );

      _logger.i('Comment added successfully: ${comment.id}');

      emit(CommentAdded(comment));

      // Reload comments after adding
      add(CommentLoadRequested(event.ticketId));
    } catch (e) {
      _logger.e('Failed to add comment: $e');
      
      // Restore previous state if available
      if (currentState is CommentLoaded) {
        emit(currentState);
      }
      
      emit(CommentError(e.toString()));
    }
  }

  /// Handle refresh comments request
  Future<void> _onCommentRefreshRequested(
    CommentRefreshRequested event,
    Emitter<CommentState> emit,
  ) async {
    // Reload comments
    add(CommentLoadRequested(event.ticketId));
  }
}