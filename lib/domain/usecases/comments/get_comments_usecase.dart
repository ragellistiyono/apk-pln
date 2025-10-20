/// Use case for getting comments from a ticket
library;

import '../../../data/models/comment_model.dart';
import '../../../data/repositories/comment_repository.dart';

/// Use case for fetching comments
class GetCommentsUseCase {
  final CommentRepository _repository;

  GetCommentsUseCase(this._repository);

  /// Execute the use case
  /// Returns CommentListResponse with all comments for the ticket
  Future<CommentListResponse> execute(String ticketId) async {
    if (ticketId.isEmpty) {
      throw ValidationException('ID tiket tidak valid');
    }

    return await _repository.getComments(ticketId);
  }
}

/// Validation exception
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => message;
}