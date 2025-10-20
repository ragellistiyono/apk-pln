/// Authentication BLoC
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/datasources/remote/api_client.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for handling authentication logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final Logger _logger = Logger();

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthTokenRefreshRequested>(_onAuthTokenRefreshRequested);
    on<AuthSessionExpiredEvent>(_onAuthSessionExpired);
  }

  /// Check if user is already authenticated (on app start)
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthChecking());

    try {
      final isAuth = await _authRepository.isAuthenticated();

      if (isAuth) {
        final token = await _authRepository.getToken();
        // Note: We don't have user details stored, so we'd need to fetch them
        // For now, just mark as authenticated with minimal info
        // In production, you might want to fetch user profile after token check
        _logger.i('User is authenticated');
        
        // Try to refresh token to ensure it's valid
        final refreshSuccess = await _authRepository.refreshToken();
        
        if (refreshSuccess) {
          final newToken = await _authRepository.getToken();
          // Would need to fetch user profile here
          // For now, emit unauthenticated to force login
          emit(const AuthUnauthenticated());
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      _logger.e('Auth check failed: $e');
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle login request
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _authRepository.login(
        event.username,
        event.password,
      );

      _logger.i('Login successful for user: ${response.user.nama}');

      emit(AuthAuthenticated(
        user: response.user,
        token: response.token,
      ));
    } on UnauthorizedException catch (e) {
      _logger.w('Login failed - invalid credentials: $e');
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      _logger.w('Login failed - network error: $e');
      emit(AuthError(e.message));
    } on ValidationException catch (e) {
      _logger.w('Login failed - validation error: $e');
      emit(AuthError(e.message));
    } catch (e) {
      _logger.e('Login failed - unexpected error: $e');
      emit(const AuthError('Login gagal. Silakan coba lagi.'));
    }
  }

  /// Handle logout request
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.logout();
      _logger.i('Logout successful');
      emit(const AuthUnauthenticated());
    } catch (e) {
      _logger.e('Logout failed: $e');
      // Even if logout fails, clear local state
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle token refresh request
  Future<void> _onAuthTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) {
      _logger.w('Token refresh requested but user not authenticated');
      return;
    }

    final currentState = state as AuthAuthenticated;
    emit(AuthRefreshing(currentState.user));

    try {
      final success = await _authRepository.refreshToken();

      if (success) {
        final newToken = await _authRepository.getToken();
        _logger.i('Token refresh successful');

        emit(AuthAuthenticated(
          user: currentState.user,
          token: newToken!,
        ));
      } else {
        _logger.w('Token refresh failed');
        emit(const AuthSessionExpired(
          'Sesi Anda telah berakhir. Silakan login kembali.',
        ));
      }
    } catch (e) {
      _logger.e('Token refresh error: $e');
      emit(const AuthSessionExpired(
        'Sesi Anda telah berakhir. Silakan login kembali.',
      ));
    }
  }

  /// Handle session expiration
  Future<void> _onAuthSessionExpired(
    AuthSessionExpiredEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.clearAuthData();
      _logger.i('Session cleared due to expiration');
      emit(const AuthSessionExpired(
        'Sesi Anda telah berakhir. Silakan login kembali.',
      ));
    } catch (e) {
      _logger.e('Failed to clear session: $e');
      emit(const AuthSessionExpired(
        'Sesi Anda telah berakhir. Silakan login kembali.',
      ));
    }
  }
}