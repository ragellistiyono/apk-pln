/// HTTP API client wrapper using Dio
library;

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../local/secure_storage.dart';

/// HTTP API client for making network requests
class ApiClient {
  late final Dio _dio;
  final SecureStorage _secureStorage;
  final Logger _logger = Logger();

  ApiClient(this._secureStorage) {
    _dio = Dio(_createBaseOptions());
    _setupInterceptors();
  }

  /// Create base options for Dio
  BaseOptions _createBaseOptions() {
    return BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: ApiConstants.connectTimeout),
      receiveTimeout: Duration(seconds: ApiConstants.receiveTimeout),
      sendTimeout: Duration(seconds: ApiConstants.sendTimeout),
      headers: {
        ApiConstants.headerContentType: ApiConstants.contentTypeJson,
        ApiConstants.headerAccept: ApiConstants.contentTypeJson,
      },
    );
  }

  /// Setup interceptors for logging and authentication
  void _setupInterceptors() {
    // Request interceptor - add auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final token = await _secureStorage.getToken();
          if (token != null) {
            options.headers[ApiConstants.headerAuthorization] =
                '${ApiConstants.authTypeBearer} $token';
          }

          _logger.d('Request: ${options.method} ${options.path}');
          _logger.d('Headers: ${options.headers}');
          if (options.data != null) {
            _logger.d('Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i(
            'Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) async {
          _logger.e('Error: ${error.response?.statusCode} ${error.message}');

          // Handle 401 Unauthorized - token expired
          if (error.response?.statusCode == ApiConstants.statusUnauthorized) {
            // Try to refresh token
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the request with new token
              final options = error.requestOptions;
              final token = await _secureStorage.getToken();
              options.headers[ApiConstants.headerAuthorization] =
                  '${ApiConstants.authTypeBearer} $token';

              try {
                final response = await _dio.fetch(options);
                return handler.resolve(response);
              } catch (e) {
                return handler.reject(error);
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// Refresh authentication token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        ApiConstants.authRefresh,
        data: {ApiConstants.keyRefreshToken: refreshToken},
      );

      if (response.statusCode == ApiConstants.statusOk) {
        final newToken = response.data[ApiConstants.keyToken] as String;
        final newRefreshToken =
            response.data[ApiConstants.keyRefreshToken] as String;

        await _secureStorage.saveToken(newToken);
        await _secureStorage.saveRefreshToken(newRefreshToken);

        return true;
      }

      return false;
    } catch (e) {
      _logger.e('Token refresh failed: $e');
      return false;
    }
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to custom exceptions
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(AppConstants.errorNetwork);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data[ApiConstants.keyMessage] ??
            error.response?.statusMessage;

        switch (statusCode) {
          case ApiConstants.statusBadRequest:
            return ValidationException(
              message ?? AppConstants.errorValidation,
            );
          case ApiConstants.statusUnauthorized:
            return UnauthorizedException(message ?? AppConstants.errorAuth);
          case ApiConstants.statusForbidden:
            return ForbiddenException(message ?? 'Akses ditolak');
          case ApiConstants.statusNotFound:
            return NotFoundException(message ?? 'Data tidak ditemukan');
          case ApiConstants.statusConflict:
            return ConflictException(message ?? 'Data sudah ada');
          case ApiConstants.statusInternalServerError:
          case ApiConstants.statusServiceUnavailable:
            return ServerException(message ?? AppConstants.errorServer);
          default:
            return ServerException(message ?? AppConstants.errorUnknown);
        }

      case DioExceptionType.cancel:
        return NetworkException('Permintaan dibatalkan');

      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return NetworkException(AppConstants.errorNetwork);
        }
        return NetworkException(AppConstants.errorUnknown);

      default:
        return NetworkException(AppConstants.errorUnknown);
    }
  }
}

/// Base API exception
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Network exception (connection issues)
class NetworkException extends ApiException {
  const NetworkException(super.message);
}

/// Server exception (5xx errors)
class ServerException extends ApiException {
  const ServerException(super.message);
}

/// Unauthorized exception (401)
class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message);
}

/// Forbidden exception (403)
class ForbiddenException extends ApiException {
  const ForbiddenException(super.message);
}

/// Not found exception (404)
class NotFoundException extends ApiException {
  const NotFoundException(super.message);
}

/// Validation exception (400)
class ValidationException extends ApiException {
  const ValidationException(super.message);
}

/// Conflict exception (409)
class ConflictException extends ApiException {
  const ConflictException(super.message);
}