/// Comment repository for managing comment operations
library;

import 'package:logger/logger.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/remote/api_client.dart';
import '../models/comment_model.dart';

/// Repository for comment operations
class CommentRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  CommentRepository(this._apiClient);

  /// Add a comment to a ticket
  Future<CommentModel> addComment(String ticketId, AddCommentRequest request) async {
    try {
      _logger.d('Adding comment to ticket: $ticketId');

      final response = await _apiClient.post(
        ApiConstants.ticketComments(ticketId),
        data: request.toJson(),
      );

      final comment = CommentModel.fromJson(
        response.data[ApiConstants.keyData],
      );

      _logger.i('Comment added successfully: ${comment.id}');
      return comment;
    } catch (e) {
      _logger.e('Failed to add comment: $e');
      rethrow;
    }
  }

  /// Get comments for a ticket
  Future<CommentListResponse> getComments(String ticketId) async {
    try {
      _logger.d('Fetching comments for ticket: $ticketId');

      final response = await _apiClient.get(
        ApiConstants.ticketComments(ticketId),
      );

      final commentList = CommentListResponse.fromJson(
        response.data[ApiConstants.keyData],
      );

      _logger.i('Fetched ${commentList.comments.length} comments');
      return commentList;
    } catch (e) {
      _logger.e('Failed to fetch comments: $e');
      rethrow;
    }
  }
}