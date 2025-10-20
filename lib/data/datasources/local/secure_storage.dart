/// Secure storage for sensitive data like JWT tokens
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/app_constants.dart';

/// Secure storage wrapper for JWT tokens and sensitive data
class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage() : _storage = const FlutterSecureStorage();

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await _storage.write(
      key: AppConstants.storageKeyToken,
      value: token,
    );
  }

  /// Get authentication token
  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.storageKeyToken);
  }

  /// Delete authentication token
  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.storageKeyToken);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(
      key: AppConstants.storageKeyRefreshToken,
      value: refreshToken,
    );
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.storageKeyRefreshToken);
  }

  /// Delete refresh token
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: AppConstants.storageKeyRefreshToken);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(
      key: AppConstants.storageKeyUserId,
      value: userId,
    );
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: AppConstants.storageKeyUserId);
  }

  /// Save user role
  Future<void> saveUserRole(String role) async {
    await _storage.write(
      key: AppConstants.storageKeyUserRole,
      value: role,
    );
  }

  /// Get user role
  Future<String?> getUserRole() async {
    return await _storage.read(key: AppConstants.storageKeyUserRole);
  }

  /// Clear all authentication data
  Future<void> clearAuthData() async {
    await Future.wait([
      deleteToken(),
      deleteRefreshToken(),
      _storage.delete(key: AppConstants.storageKeyUserId),
      _storage.delete(key: AppConstants.storageKeyUserRole),
    ]);
  }

  /// Check if user is authenticated (has valid token)
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}