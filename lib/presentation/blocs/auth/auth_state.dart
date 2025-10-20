/// Authentication states
library;

import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

/// Base class for authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - checking authentication status
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when checking authentication status
class AuthChecking extends AuthState {
  const AuthChecking();
}

/// State when user is authenticated
class AuthAuthenticated extends AuthState {
  final UserModel user;
  final String token;

  const AuthAuthenticated({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when login is in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when authentication fails
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when token refresh is in progress
class AuthRefreshing extends AuthState {
  final UserModel user;

  const AuthRefreshing(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when session has expired
class AuthSessionExpired extends AuthState {
  final String message;

  const AuthSessionExpired(this.message);

  @override
  List<Object?> get props => [message];
}