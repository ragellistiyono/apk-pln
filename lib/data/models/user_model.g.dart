// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'role': _$UserRoleEnumMap[instance.role]!,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.employee: 'employee',
  UserRole.technician: 'technician',
  UserRole.admin: 'admin',
};

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      nip: json['nip'] as String,
      region: $enumDecode(_$RegionEnumMap, json['region']),
      createdTicketsCount: (json['created_tickets_count'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'nip': instance.nip,
      'region': _$RegionEnumMap[instance.region]!,
      'created_tickets_count': instance.createdTicketsCount,
    };

const _$RegionEnumMap = {
  Region.kantorInduk: 'kantorInduk',
  Region.uptSurabaya: 'uptSurabaya',
  Region.uptMalang: 'uptMalang',
  Region.uptMadiun: 'uptMadiun',
  Region.uptProbolinggo: 'uptProbolinggo',
  Region.uptGresik: 'uptGresik',
  Region.uptBali: 'uptBali',
  Region.allUit: 'allUit',
};

TechnicianModel _$TechnicianModelFromJson(Map<String, dynamic> json) =>
    TechnicianModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      wilayah: $enumDecodeNullable(_$RegionEnumMap, json['wilayah']),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => $enumDecode(_$TicketCategoryEnumMap, e))
          .toList(),
      subCategories: (json['sub_categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      assignedTicketsCount: (json['assigned_tickets_count'] as num?)?.toInt(),
      completedTicketsCount: (json['completed_tickets_count'] as num?)?.toInt(),
      isAvailable: json['is_available'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TechnicianModelToJson(TechnicianModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'wilayah': _$RegionEnumMap[instance.wilayah],
      'categories':
          instance.categories.map((e) => _$TicketCategoryEnumMap[e]!).toList(),
      'sub_categories': instance.subCategories,
      'assigned_tickets_count': instance.assignedTicketsCount,
      'completed_tickets_count': instance.completedTicketsCount,
      'is_available': instance.isAvailable,
    };

const _$TicketCategoryEnumMap = {
  TicketCategory.hardware: 'hardware',
  TicketCategory.jaringanKoneksi: 'jaringanKoneksi',
  TicketCategory.zoom: 'zoom',
  TicketCategory.akun: 'akun',
  TicketCategory.aplikasi: 'aplikasi',
};

AdminModel _$AdminModelFromJson(Map<String, dynamic> json) => AdminModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      nomorWa: json['nomor_wa'] as String,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AdminModelToJson(AdminModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'nomor_wa': instance.nomorWa,
      'permissions': instance.permissions,
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: json['token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refresh_token': instance.refreshToken,
      'user': instance.user,
    };
