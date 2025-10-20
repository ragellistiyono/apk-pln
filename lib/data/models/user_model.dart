/// User data models for Employee, Technician, and Admin
library;

import 'package:json_annotation/json_annotation.dart';
import '../../core/constants/app_constants.dart';

part 'user_model.g.dart';

/// Base user model
@JsonSerializable()
class UserModel {
  final String id;
  final String nama;
  final UserRole role;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.nama,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Note: copyWith removed from base class
  // Child classes implement their own type-specific copyWith methods
}

/// Employee model - extends UserModel with employee-specific fields
@JsonSerializable()
class EmployeeModel extends UserModel {
  final String nip;
  final Region region;

  @JsonKey(name: 'created_tickets_count')
  final int? createdTicketsCount;

  const EmployeeModel({
    required super.id,
    required super.nama,
    required this.nip,
    required this.region,
    this.createdTicketsCount,
    super.createdAt,
    super.updatedAt,
  }) : super(role: UserRole.employee);

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  EmployeeModel copyWith({
    String? id,
    String? nama,
    String? nip,
    Region? region,
    int? createdTicketsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      nip: nip ?? this.nip,
      region: region ?? this.region,
      createdTicketsCount: createdTicketsCount ?? this.createdTicketsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Technician model - extends UserModel with technician-specific fields
@JsonSerializable()
class TechnicianModel extends UserModel {
  final Region? wilayah; // Can be null for central technicians
  final List<TicketCategory> categories;

  @JsonKey(name: 'sub_categories')
  final List<String> subCategories;

  @JsonKey(name: 'assigned_tickets_count')
  final int? assignedTicketsCount;

  @JsonKey(name: 'completed_tickets_count')
  final int? completedTicketsCount;

  @JsonKey(name: 'is_available')
  final bool isAvailable;

  const TechnicianModel({
    required super.id,
    required super.nama,
    this.wilayah,
    required this.categories,
    required this.subCategories,
    this.assignedTicketsCount,
    this.completedTicketsCount,
    this.isAvailable = true,
    super.createdAt,
    super.updatedAt,
  }) : super(role: UserRole.technician);

  factory TechnicianModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TechnicianModelToJson(this);

  /// Check if technician handles this category
  bool handlesCategory(TicketCategory category) {
    return categories.contains(category);
  }

  /// Check if technician handles this sub-category
  bool handlesSubCategory(String subCategory) {
    return subCategories.contains(subCategory);
  }

  /// Check if technician serves this region
  bool servesRegion(Region region) {
    // No wilayah means central technician (serves all regions)
    if (wilayah == null) return true;
    // ALL UIT serves all regions
    if (wilayah == Region.allUit) return true;
    // Regional technician serves only their region
    return wilayah == region;
  }

  /// Check if technician matches ticket criteria
  bool matchesTicket({
    required TicketCategory category,
    String? subCategory,
    required Region employeeRegion,
  }) {
    // Must handle the category
    if (!handlesCategory(category)) return false;

    // If sub-category specified, must handle it
    if (subCategory != null && !handlesSubCategory(subCategory)) {
      return false;
    }

    // Must serve the region
    if (!servesRegion(employeeRegion)) return false;

    // Must be available
    if (!isAvailable) return false;

    return true;
  }

  TechnicianModel copyWith({
    String? id,
    String? nama,
    Region? wilayah,
    List<TicketCategory>? categories,
    List<String>? subCategories,
    int? assignedTicketsCount,
    int? completedTicketsCount,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TechnicianModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      wilayah: wilayah ?? this.wilayah,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      assignedTicketsCount: assignedTicketsCount ?? this.assignedTicketsCount,
      completedTicketsCount:
          completedTicketsCount ?? this.completedTicketsCount,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Admin model - extends UserModel with admin-specific fields
@JsonSerializable()
class AdminModel extends UserModel {
  @JsonKey(name: 'nomor_wa')
  final String nomorWa;

  final List<String>? permissions;

  const AdminModel({
    required super.id,
    required super.nama,
    required this.nomorWa,
    this.permissions,
    super.createdAt,
    super.updatedAt,
  }) : super(role: UserRole.admin);

  factory AdminModel.fromJson(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdminModelToJson(this);

  /// Check if admin has specific permission
  bool hasPermission(String permission) {
    return permissions?.contains(permission) ?? false;
  }

  AdminModel copyWith({
    String? id,
    String? nama,
    String? nomorWa,
    List<String>? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      nomorWa: nomorWa ?? this.nomorWa,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Login request model
@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// Login response model
@JsonSerializable()
class LoginResponse {
  final String token;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  final UserModel user;

  const LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}