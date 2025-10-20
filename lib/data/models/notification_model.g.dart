// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      ticketId: json['ticket_id'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      message: json['message'] as String,
      readStatus: json['read_status'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'ticket_id': instance.ticketId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'message': instance.message,
      'read_status': instance.readStatus,
      'created_at': instance.createdAt.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.ticketAssigned: 'ticket_assigned',
  NotificationType.ticketAccepted: 'ticket_accepted',
  NotificationType.ticketCompleted: 'ticket_completed',
  NotificationType.newComment: 'new_comment',
};

NotificationListResponse _$NotificationListResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationListResponse(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      unreadCount: (json['unread_count'] as num).toInt(),
    );

Map<String, dynamic> _$NotificationListResponseToJson(
        NotificationListResponse instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'total': instance.total,
      'unread_count': instance.unreadCount,
    };
