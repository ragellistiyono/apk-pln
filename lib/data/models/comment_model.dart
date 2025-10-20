/// Comment data model with JSON serialization
library;

import 'package:json_annotation/json_annotation.dart';
import '../../core/constants/app_constants.dart';

part 'comment_model.g.dart';

/// Comment model representing a comment on a ticket
@JsonSerializable()
class CommentModel {
  final String id;

  @JsonKey(name: 'ticket_id')
  final String ticketId;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'user_nama')
  final String userName;

  @JsonKey(name: 'user_type')
  final UserRole userType;

  final String text;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'is_read')
  final bool isRead;

  const CommentModel({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.userName,
    required this.userType,
    required this.text,
    required this.createdAt,
    this.isRead = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  /// Check if comment is from employee
  bool get isFromEmployee => userType == UserRole.employee;

  /// Check if comment is from technician
  bool get isFromTechnician => userType == UserRole.technician;

  /// Get time elapsed since comment was created
  Duration get elapsedSinceCreation {
    return DateTime.now().difference(createdAt);
  }

  /// Get formatted time elapsed string in Indonesian
  String getFormattedTime() {
    final duration = elapsedSinceCreation;
    
    if (duration.inDays > 7) {
      final weeks = (duration.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else if (duration.inDays > 0) {
      return '${duration.inDays} hari yang lalu';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} jam yang lalu';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  CommentModel copyWith({
    String? id,
    String? ticketId,
    String? userId,
    String? userName,
    UserRole? userType,
    String? text,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return CommentModel(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userType: userType ?? this.userType,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// Request model for adding a comment
@JsonSerializable()
class AddCommentRequest {
  final String text;

  const AddCommentRequest({
    required this.text,
  });

  factory AddCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCommentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddCommentRequestToJson(this);
}

/// Response model for comment list
@JsonSerializable()
class CommentListResponse {
  final List<CommentModel> comments;
  final int total;

  const CommentListResponse({
    required this.comments,
    required this.total,
  });

  factory CommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommentListResponseToJson(this);
}