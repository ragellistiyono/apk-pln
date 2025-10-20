/// Ticket data model with JSON serialization
library;

import 'package:json_annotation/json_annotation.dart';
import '../../core/constants/app_constants.dart';

part 'ticket_model.g.dart';

/// Ticket model representing a support ticket
@JsonSerializable()
class TicketModel {
  final String id;

  @JsonKey(name: 'employee_id')
  final String employeeId;

  @JsonKey(name: 'employee_nama')
  final String? employeeNama;

  @JsonKey(name: 'employee_nip')
  final String? employeeNip;

  @JsonKey(name: 'technician_id')
  final String? technicianId;

  @JsonKey(name: 'technician_nama')
  final String? technicianNama;

  final String deskripsi;
  final TicketCategory kategori;

  @JsonKey(name: 'sub_kategori')
  final String? subKategori;

  final TicketStatus status;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'accepted_at')
  final DateTime? acceptedAt;

  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @JsonKey(name: 'resolution_notes')
  final String? resolutionNotes;

  @JsonKey(name: 'comment_count')
  final int? commentCount;

  @JsonKey(name: 'unread_comments')
  final int? unreadComments;

  const TicketModel({
    required this.id,
    required this.employeeId,
    this.employeeNama,
    this.employeeNip,
    this.technicianId,
    this.technicianNama,
    required this.deskripsi,
    required this.kategori,
    this.subKategori,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
    this.resolutionNotes,
    this.commentCount,
    this.unreadComments,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketModelToJson(this);

  /// Check if ticket is pending
  bool get isPending => status == TicketStatus.pending;

  /// Check if ticket is in progress
  bool get isInProgress => status == TicketStatus.inProgress;

  /// Check if ticket is completed
  bool get isCompleted => status == TicketStatus.completed;

  /// Get time elapsed since creation
  Duration get elapsedSinceCreation {
    return DateTime.now().difference(createdAt);
  }

  /// Get time elapsed since last status change
  Duration get elapsedSinceLastUpdate {
    if (completedAt != null) {
      return DateTime.now().difference(completedAt!);
    }
    if (acceptedAt != null) {
      return DateTime.now().difference(acceptedAt!);
    }
    return elapsedSinceCreation;
  }

  /// Get formatted time elapsed string in Indonesian
  String getFormattedElapsedTime() {
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

  /// Get status display text in Indonesian
  String get statusText {
    switch (status) {
      case TicketStatus.pending:
        return 'Menunggu';
      case TicketStatus.inProgress:
        return 'Sedang Dikerjakan';
      case TicketStatus.completed:
        return 'Selesai';
    }
  }

  TicketModel copyWith({
    String? id,
    String? employeeId,
    String? employeeNama,
    String? employeeNip,
    String? technicianId,
    String? technicianNama,
    String? deskripsi,
    TicketCategory? kategori,
    String? subKategori,
    TicketStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
    String? resolutionNotes,
    int? commentCount,
    int? unreadComments,
  }) {
    return TicketModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeNama: employeeNama ?? this.employeeNama,
      employeeNip: employeeNip ?? this.employeeNip,
      technicianId: technicianId ?? this.technicianId,
      technicianNama: technicianNama ?? this.technicianNama,
      deskripsi: deskripsi ?? this.deskripsi,
      kategori: kategori ?? this.kategori,
      subKategori: subKategori ?? this.subKategori,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      commentCount: commentCount ?? this.commentCount,
      unreadComments: unreadComments ?? this.unreadComments,
    );
  }
}

/// Request model for creating a ticket
@JsonSerializable()
class CreateTicketRequest {
  final String deskripsi;
  final TicketCategory kategori;

  @JsonKey(name: 'sub_kategori')
  final String? subKategori;

  @JsonKey(name: 'technician_id')
  final String technicianId;

  const CreateTicketRequest({
    required this.deskripsi,
    required this.kategori,
    this.subKategori,
    required this.technicianId,
  });

  factory CreateTicketRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTicketRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTicketRequestToJson(this);
}

/// Request model for completing a ticket
@JsonSerializable()
class CompleteTicketRequest {
  @JsonKey(name: 'resolution_notes')
  final String resolutionNotes;

  const CompleteTicketRequest({
    required this.resolutionNotes,
  });

  factory CompleteTicketRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteTicketRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteTicketRequestToJson(this);
}

/// Response model for paginated ticket list
@JsonSerializable()
class TicketListResponse {
  final List<TicketModel> tickets;
  final int total;
  final int page;
  final int limit;

  const TicketListResponse({
    required this.tickets,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory TicketListResponse.fromJson(Map<String, dynamic> json) =>
      _$TicketListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TicketListResponseToJson(this);

  /// Check if there are more pages
  bool get hasMore => (page * limit) < total;

  /// Get next page number
  int get nextPage => page + 1;
}