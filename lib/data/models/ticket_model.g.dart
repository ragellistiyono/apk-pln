// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => TicketModel(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      employeeNama: json['employee_nama'] as String?,
      employeeNip: json['employee_nip'] as String?,
      technicianId: json['technician_id'] as String?,
      technicianNama: json['technician_nama'] as String?,
      deskripsi: json['deskripsi'] as String,
      kategori: $enumDecode(_$TicketCategoryEnumMap, json['kategori']),
      subKategori: json['sub_kategori'] as String?,
      status: $enumDecode(_$TicketStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      acceptedAt: json['accepted_at'] == null
          ? null
          : DateTime.parse(json['accepted_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      resolutionNotes: json['resolution_notes'] as String?,
      commentCount: (json['comment_count'] as num?)?.toInt(),
      unreadComments: (json['unread_comments'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TicketModelToJson(TicketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_id': instance.employeeId,
      'employee_nama': instance.employeeNama,
      'employee_nip': instance.employeeNip,
      'technician_id': instance.technicianId,
      'technician_nama': instance.technicianNama,
      'deskripsi': instance.deskripsi,
      'kategori': _$TicketCategoryEnumMap[instance.kategori]!,
      'sub_kategori': instance.subKategori,
      'status': _$TicketStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'accepted_at': instance.acceptedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'resolution_notes': instance.resolutionNotes,
      'comment_count': instance.commentCount,
      'unread_comments': instance.unreadComments,
    };

const _$TicketCategoryEnumMap = {
  TicketCategory.hardware: 'hardware',
  TicketCategory.jaringanKoneksi: 'jaringanKoneksi',
  TicketCategory.zoom: 'zoom',
  TicketCategory.akun: 'akun',
  TicketCategory.aplikasi: 'aplikasi',
};

const _$TicketStatusEnumMap = {
  TicketStatus.pending: 'pending',
  TicketStatus.inProgress: 'inProgress',
  TicketStatus.completed: 'completed',
};

CreateTicketRequest _$CreateTicketRequestFromJson(Map<String, dynamic> json) =>
    CreateTicketRequest(
      deskripsi: json['deskripsi'] as String,
      kategori: $enumDecode(_$TicketCategoryEnumMap, json['kategori']),
      subKategori: json['sub_kategori'] as String?,
      technicianId: json['technician_id'] as String,
    );

Map<String, dynamic> _$CreateTicketRequestToJson(
        CreateTicketRequest instance) =>
    <String, dynamic>{
      'deskripsi': instance.deskripsi,
      'kategori': _$TicketCategoryEnumMap[instance.kategori]!,
      'sub_kategori': instance.subKategori,
      'technician_id': instance.technicianId,
    };

CompleteTicketRequest _$CompleteTicketRequestFromJson(
        Map<String, dynamic> json) =>
    CompleteTicketRequest(
      resolutionNotes: json['resolution_notes'] as String,
    );

Map<String, dynamic> _$CompleteTicketRequestToJson(
        CompleteTicketRequest instance) =>
    <String, dynamic>{
      'resolution_notes': instance.resolutionNotes,
    };

TicketListResponse _$TicketListResponseFromJson(Map<String, dynamic> json) =>
    TicketListResponse(
      tickets: (json['tickets'] as List<dynamic>)
          .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$TicketListResponseToJson(TicketListResponse instance) =>
    <String, dynamic>{
      'tickets': instance.tickets,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };
