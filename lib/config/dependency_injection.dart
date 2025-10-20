/// Dependency injection setup
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/datasources/local/secure_storage.dart';
import '../data/datasources/remote/api_client.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/ticket_repository.dart';
import '../domain/usecases/tickets/create_ticket_usecase.dart';
import '../domain/usecases/tickets/get_tickets_usecase.dart';
import '../data/repositories/comment_repository.dart';
import '../domain/usecases/comments/add_comment_usecase.dart';
import '../domain/usecases/comments/get_comments_usecase.dart';
import '../presentation/blocs/auth/auth_bloc.dart';
import '../presentation/blocs/auth/auth_event.dart';
import '../presentation/blocs/comment/comment_bloc.dart';
import '../presentation/blocs/ticket/ticket_bloc.dart';

/// Dependency injection container
class DependencyInjection {
  DependencyInjection._(); // Private constructor

  // Singleton instances
  static final SecureStorage _secureStorage = SecureStorage();
  static final ApiClient _apiClient = ApiClient(_secureStorage);

  // Repositories
  static final AuthRepository _authRepository = AuthRepository(
    _apiClient,
    _secureStorage,
  );

  static final TicketRepository _ticketRepository = TicketRepository(
    _apiClient,
  );

  static final CommentRepository _commentRepository = CommentRepository(
    _apiClient,
  );

  // Use Cases (Tickets)
  static final CreateTicketUseCase _createTicketUseCase = CreateTicketUseCase(
    _ticketRepository,
  );

  static final GetTicketsUseCase _getTicketsUseCase = GetTicketsUseCase(
    _ticketRepository,
  );

  static final GetTicketByIdUseCase _getTicketByIdUseCase =
      GetTicketByIdUseCase(_ticketRepository);

  // Use Cases (Comments)
  static final AddCommentUseCase _addCommentUseCase = AddCommentUseCase(
    _commentRepository,
  );

  static final GetCommentsUseCase _getCommentsUseCase = GetCommentsUseCase(
    _commentRepository,
  );

  // BLoCs - create new instances for each use
  static AuthBloc createAuthBloc() => AuthBloc(_authRepository);

  static TicketBloc createTicketBloc() => TicketBloc(
        _ticketRepository,
        _createTicketUseCase,
        _getTicketsUseCase,
        _getTicketByIdUseCase,
      );

  static CommentBloc createCommentBloc() => CommentBloc(
        _addCommentUseCase,
        _getCommentsUseCase,
      );

  // Getters for direct access if needed
  static SecureStorage get secureStorage => _secureStorage;
  static ApiClient get apiClient => _apiClient;
  static AuthRepository get authRepository => _authRepository;
  static TicketRepository get ticketRepository => _ticketRepository;

  /// Initialize dependencies (call in main.dart)
  static Future<void> init() async {
    // Initialize any async dependencies here
    // For now, just ensure singletons are created
  }

  /// Dispose resources (call when app is closing)
  static Future<void> dispose() async {
    // Dispose any resources that need cleanup
    // Close database connections, cancel streams, etc.
  }
}

/// BLoC providers for the app
class AppBlocProviders {
  AppBlocProviders._(); // Private constructor

  /// Get list of BLoC providers for the app
  static List<BlocProvider> get providers {
    return [
      BlocProvider<AuthBloc>(
        create: (context) => DependencyInjection.createAuthBloc()
          ..add(const AuthCheckRequested()),
      ),
      BlocProvider<TicketBloc>(
        create: (context) => DependencyInjection.createTicketBloc(),
      ),
      // BlocProvider<CommentBloc>(
      //   create: (context) => DependencyInjection.createCommentBloc(),
      // ),
      // BlocProvider<NotificationBloc>(
      //   create: (context) => DependencyInjection.createNotificationBloc(),
      // ),
    ];
  }
}