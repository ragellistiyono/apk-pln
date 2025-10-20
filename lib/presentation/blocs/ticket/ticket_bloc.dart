/// Ticket BLoC for managing ticket state
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../data/repositories/ticket_repository.dart';
import '../../../domain/usecases/tickets/create_ticket_usecase.dart';
import '../../../domain/usecases/tickets/get_tickets_usecase.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

/// BLoC for handling ticket operations
class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository _ticketRepository;
  final CreateTicketUseCase _createTicketUseCase;
  final GetTicketsUseCase _getTicketsUseCase;
  final GetTicketByIdUseCase _getTicketByIdUseCase;
  final Logger _logger = Logger();

  TicketBloc(
    this._ticketRepository,
    this._createTicketUseCase,
    this._getTicketsUseCase,
    this._getTicketByIdUseCase,
  ) : super(const TicketInitial()) {
    on<TicketLoadRequested>(_onTicketLoadRequested);
    on<TicketLoadMoreRequested>(_onTicketLoadMoreRequested);
    on<TicketCreateRequested>(_onTicketCreateRequested);
    on<TicketDetailLoadRequested>(_onTicketDetailLoadRequested);
    on<TicketAcceptRequested>(_onTicketAcceptRequested);
    on<TicketCompleteRequested>(_onTicketCompleteRequested);
    on<TicketFilterChanged>(_onTicketFilterChanged);
    on<TicketRefreshRequested>(_onTicketRefreshRequested);
    on<TechnicianLoadRequested>(_onTechnicianLoadRequested);
  }

  /// Handle ticket load request
  Future<void> _onTicketLoadRequested(
    TicketLoadRequested event,
    Emitter<TicketState> emit,
  ) async {
    try {
      // If refreshing and already have data, keep showing it
      if (event.refresh && state is TicketLoaded) {
        // Keep current state while refreshing
      } else {
        emit(const TicketLoading());
      }

      _logger.d('Loading tickets, page: ${event.page}');

      final response = await _getTicketsUseCase.execute(
        page: event.page,
        status: event.status,
        category: event.category,
        employeeId: event.employeeId,
        technicianId: event.technicianId,
        search: event.search,
      );

      _logger.i('Loaded ${response.tickets.length} tickets');

      emit(TicketLoaded(
        tickets: response.tickets,
        total: response.total,
        currentPage: response.page,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      _logger.e('Failed to load tickets: $e');
      emit(TicketError(e.toString()));
    }
  }

  /// Handle load more tickets (pagination)
  Future<void> _onTicketLoadMoreRequested(
    TicketLoadMoreRequested event,
    Emitter<TicketState> emit,
  ) async {
    if (state is! TicketLoaded) return;

    final currentState = state as TicketLoaded;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      _logger.d('Loading more tickets, page: ${currentState.currentPage + 1}');

      final response = await _getTicketsUseCase.execute(
        page: currentState.currentPage + 1,
      );

      _logger.i('Loaded ${response.tickets.length} more tickets');

      emit(TicketLoaded(
        tickets: [...currentState.tickets, ...response.tickets],
        total: response.total,
        currentPage: response.page,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      _logger.e('Failed to load more tickets: $e');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Handle create ticket request
  Future<void> _onTicketCreateRequested(
    TicketCreateRequested event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketCreating());

    try {
      _logger.d('Creating ticket: ${event.request.kategori.displayName}');

      final ticket = await _createTicketUseCase.execute(event.request);

      _logger.i('Ticket created successfully: ${ticket.id}');

      emit(TicketCreated(ticket));
    } catch (e) {
      _logger.e('Failed to create ticket: $e');
      emit(TicketError(e.toString()));
    }
  }

  /// Handle load ticket detail request
  Future<void> _onTicketDetailLoadRequested(
    TicketDetailLoadRequested event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketDetailLoading());

    try {
      _logger.d('Loading ticket detail: ${event.ticketId}');

      final ticket = await _getTicketByIdUseCase.execute(event.ticketId);

      _logger.i('Ticket detail loaded: ${ticket.id}');

      emit(TicketDetailLoaded(ticket));
    } catch (e) {
      _logger.e('Failed to load ticket detail: $e');
      emit(TicketError(e.toString()));
    }
  }

  /// Handle accept ticket request (technician)
  Future<void> _onTicketAcceptRequested(
    TicketAcceptRequested event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketAccepting());

    try {
      _logger.d('Accepting ticket: ${event.ticketId}');

      final ticket = await _ticketRepository.acceptTicket(event.ticketId);

      _logger.i('Ticket accepted: ${ticket.id}');

      emit(TicketAccepted(ticket));
    } catch (e) {
      _logger.e('Failed to accept ticket: $e');
      emit(TicketError(e.toString()));
    }
  }

  /// Handle complete ticket request (technician)
  Future<void> _onTicketCompleteRequested(
    TicketCompleteRequested event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketCompleting());

    try {
      _logger.d('Completing ticket: ${event.ticketId}');

      final ticket = await _ticketRepository.completeTicket(
        event.ticketId,
        event.request,
      );

      _logger.i('Ticket completed: ${ticket.id}');

      emit(TicketCompleted(ticket));
    } catch (e) {
      _logger.e('Failed to complete ticket: $e');
      emit(TicketError(e.toString()));
    }
  }

  /// Handle filter changed
  Future<void> _onTicketFilterChanged(
    TicketFilterChanged event,
    Emitter<TicketState> emit,
  ) async {
    // Reload tickets with new filters
    add(TicketLoadRequested(
      status: event.status,
      category: event.category,
      search: event.search,
    ));
  }

  /// Handle refresh request
  Future<void> _onTicketRefreshRequested(
    TicketRefreshRequested event,
    Emitter<TicketState> emit,
  ) async {
    // Reload tickets from page 1
    add(const TicketLoadRequested(refresh: true));
  }

  /// Handle load technicians request
  Future<void> _onTechnicianLoadRequested(
    TechnicianLoadRequested event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TechnicianLoading());

    try {
      _logger.d('Loading technicians with filters');

      final technicians = await _ticketRepository.getTechnicians(
        category: event.category,
        subCategory: event.subCategory,
        region: event.region,
      );

      _logger.i('Loaded ${technicians.length} technicians');

      emit(TechnicianLoaded(technicians));
    } catch (e) {
      _logger.e('Failed to load technicians: $e');
      emit(TicketError(e.toString()));
    }
  }
}