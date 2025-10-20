/// Use case for adding a comment to a ticket
library;

import '../../../data/models/comment_model.dart';
import '../../../data/repositories/comment_repository.dart';

/// Use case for adding a comment
class AddCommentUseCase {
  final CommentRepository _repository;

  AddCommentUseCase(this._repository);

  /// Execute the use case
  /// Returns created CommentModel on success
  Future<CommentModel> execute(String ticketId, String text) async {
    if (ticketId.isEmpty) {
      throw ValidationException('ID tiket tidak valid');
    }

    if (text.trim().isEmpty) {
      throw ValidationException('Komentar tidak boleh kosong');
    }

    if (text.trim().length < 3) {
      throw ValidationException('Komentar minimal 3 karakter');
    }

    if (text.trim().length > 1000) {
      throw ValidationException('Komentar maksimal 1000 karakter');
    }

    final request = AddCommentRequest(text: text.trim());
    return await _repository.addComment(ticketId, request);
  }
}

/// Validation exception
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => message;
}