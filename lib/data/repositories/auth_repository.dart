/// Authentication repository for login/logout operations
library;

import 'package:logger/logger.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/local/secure_storage.dart';
import '../datasources/remote/api_client.dart';
import '../models/user_model.dart';

/// Repository for authentication operations
class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;
  final Logger _logger = Logger();

  AuthRepository(this._apiClient, this._secureStorage);

  /// Login with username and password
  /// Returns LoginResponse with user data and tokens
  Future<LoginResponse> login(String username, String password) async {
    try {
      _logger.d('Attempting login for username: $username');

      final request = LoginRequest(
        username: username,
        password: password,
      );

      final response = await _apiClient.post(
        ApiConstants.authLogin,
        data: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(
        response.data[ApiConstants.keyData],
      );

      // Save authentication data
      await _saveAuthData(loginResponse);

      _logger.i('Login successful for user: ${loginResponse.user.id}');
      return loginResponse;
    } catch (e) {
      _logger.e('Login failed: $e');
      rethrow;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      _logger.d('Attempting logout');

      // Call logout endpoint (optional - backend may just invalidate token)
      try {
        await _apiClient.post(ApiConstants.authLogout);
      } catch (e) {
        _logger.w('Logout API call failed (continuing): $e');
        // Continue with local logout even if API fails
      }

      // Clear local authentication data
      await _secureStorage.clearAuthData();

      _logger.i('Logout successful');
    } catch (e) {
      _logger.e('Logout failed: $e');
      rethrow;
    }
  }

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    return await _secureStorage.isAuthenticated();
  }

  /// Get current user ID from storage
  Future<String?> getCurrentUserId() async {
    return await _secureStorage.getUserId();
  }

  /// Get current user role from storage
  Future<String?> getCurrentUserRole() async {
    return await _secureStorage.getUserRole();
  }

  /// Refresh authentication token
  /// Returns true if refresh was successful
  Future<bool> refreshToken() async {
    try {
      _logger.d('Attempting token refresh');

      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) {
        _logger.w('No refresh token available');
        return false;
      }

      final response = await _apiClient.post(
        ApiConstants.authRefresh,
        data: {ApiConstants.keyRefreshToken: refreshToken},
      );

      final newToken = response.data[ApiConstants.keyToken] as String;
      final newRefreshToken =
          response.data[ApiConstants.keyRefreshToken] as String;

      await _secureStorage.saveToken(newToken);
      await _secureStorage.saveRefreshToken(newRefreshToken);

      _logger.i('Token refresh successful');
      return true;
    } catch (e) {
      _logger.e('Token refresh failed: $e');
      return false;
    }
  }

  /// Save authentication data to secure storage
  Future<void> _saveAuthData(LoginResponse response) async {
    await Future.wait([
      _secureStorage.saveToken(response.token),
      _secureStorage.saveRefreshToken(response.refreshToken),
      _secureStorage.saveUserId(response.user.id),
      _secureStorage.saveUserRole(response.user.role.name),
    ]);
  }

  /// Get stored authentication token
  Future<String?> getToken() async {
    return await _secureStorage.getToken();
  }

  /// Clear all authentication data (useful for forced logout)
  Future<void> clearAuthData() async {
    await _secureStorage.clearAuthData();
    _logger.i('Authentication data cleared');
  }
}