// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: json['id'] as String,
      ticketId: json['ticket_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_nama'] as String,
      userType: $enumDecode(_$UserRoleEnumMap, json['user_type']),
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticket_id': instance.ticketId,
      'user_id': instance.userId,
      'user_nama': instance.userName,
      'user_type': _$UserRoleEnumMap[instance.userType]!,
      'text': instance.text,
      'created_at': instance.createdAt.toIso8601String(),
      'is_read': instance.isRead,
    };

const _$UserRoleEnumMap = {
  UserRole.employee: 'employee',
  UserRole.technician: 'technician',
  UserRole.admin: 'admin',
};

AddCommentRequest _$AddCommentRequestFromJson(Map<String, dynamic> json) =>
    AddCommentRequest(
      text: json['text'] as String,
    );

Map<String, dynamic> _$AddCommentRequestToJson(AddCommentRequest instance) =>
    <String, dynamic>{
      'text': instance.text,
    };

CommentListResponse _$CommentListResponseFromJson(Map<String, dynamic> json) =>
    CommentListResponse(
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$CommentListResponseToJson(
        CommentListResponse instance) =>
    <String, dynamic>{
      'comments': instance.comments,
      'total': instance.total,
    };
