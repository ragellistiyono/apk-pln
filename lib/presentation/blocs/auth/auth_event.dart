/// Authentication events
library;

import 'package:equatable/equatable.dart';

/// Base class for authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check authentication status on app start
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event when user attempts to login
class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

/// Event when user requests logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event when token refresh is needed
class AuthTokenRefreshRequested extends AuthEvent {
  const AuthTokenRefreshRequested();
}

/// Event when authentication fails and needs to be cleared
class AuthSessionExpiredEvent extends AuthEvent {
  const AuthSessionExpiredEvent();
}