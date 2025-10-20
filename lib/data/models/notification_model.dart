/// Notification data model with JSON serialization
library;

import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

/// Notification type enumeration
enum NotificationType {
  @JsonValue('ticket_assigned')
  ticketAssigned,
  
  @JsonValue('ticket_accepted')
  ticketAccepted,
  
  @JsonValue('ticket_completed')
  ticketCompleted,
  
  @JsonValue('new_comment')
  newComment,
}

/// Notification model
@JsonSerializable()
class NotificationModel {
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'ticket_id')
  final String ticketId;

  final NotificationType type;
  final String message;

  @JsonKey(name: 'read_status')
  final bool readStatus;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Optional metadata as JSON
  final Map<String, dynamic>? metadata;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.ticketId,
    required this.type,
    required this.message,
    required this.readStatus,
    required this.createdAt,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  /// Check if notification is read
  bool get isRead => readStatus;

  /// Check if notification is unread
  bool get isUnread => !readStatus;

  /// Get time elapsed since notification was created
  Duration get elapsedSinceCreation {
    return DateTime.now().difference(createdAt);
  }

  /// Get formatted time elapsed string in Indonesian
  String getFormattedTime() {
    final duration = elapsedSinceCreation;
    
    if (duration.inDays > 0) {
      return '${duration.inDays} hari yang lalu';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} jam yang lalu';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  /// Get notification title based on type in Indonesian
  String get title {
    switch (type) {
      case NotificationType.ticketAssigned:
        return 'Tiket Baru Diterima';
      case NotificationType.ticketAccepted:
        return 'Tiket Diterima Teknisi';
      case NotificationType.ticketCompleted:
        return 'Tiket Selesai';
      case NotificationType.newComment:
        return 'Komentar Baru';
    }
  }

  /// Get notification icon based on type
  String get iconName {
    switch (type) {
      case NotificationType.ticketAssigned:
        return 'assignment';
      case NotificationType.ticketAccepted:
        return 'check_circle';
      case NotificationType.ticketCompleted:
        return 'done_all';
      case NotificationType.newComment:
        return 'comment';
    }
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? ticketId,
    NotificationType? type,
    String? message,
    bool? readStatus,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ticketId: ticketId ?? this.ticketId,
      type: type ?? this.type,
      message: message ?? this.message,
      readStatus: readStatus ?? this.readStatus,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Response model for notification list
@JsonSerializable()
class NotificationListResponse {
  final List<NotificationModel> notifications;
  final int total;
  
  @JsonKey(name: 'unread_count')
  final int unreadCount;

  const NotificationListResponse({
    required this.notifications,
    required this.total,
    required this.unreadCount,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationListResponseToJson(this);
}