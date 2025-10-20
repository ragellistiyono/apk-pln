/// Ticket events
library;

import 'package:equatable/equatable.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/ticket_model.dart';

/// Base class for ticket events
abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load tickets
class TicketLoadRequested extends TicketEvent {
  final int page;
  final TicketStatus? status;
  final TicketCategory? category;
  final String? employeeId;
  final String? technicianId;
  final String? search;
  final bool refresh;

  const TicketLoadRequested({
    this.page = 1,
    this.status,
    this.category,
    this.employeeId,
    this.technicianId,
    this.search,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [
        page,
        status,
        category,
        employeeId,
        technicianId,
        search,
        refresh,
      ];
}

/// Event to load more tickets (pagination)
class TicketLoadMoreRequested extends TicketEvent {
  const TicketLoadMoreRequested();
}

/// Event to create a new ticket
class TicketCreateRequested extends TicketEvent {
  final CreateTicketRequest request;

  const TicketCreateRequested(this.request);

  @override
  List<Object?> get props => [request];
}

/// Event to load a single ticket by ID
class TicketDetailLoadRequested extends TicketEvent {
  final String ticketId;

  const TicketDetailLoadRequested(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

/// Event to accept a ticket (technician)
class TicketAcceptRequested extends TicketEvent {
  final String ticketId;

  const TicketAcceptRequested(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

/// Event to complete a ticket (technician)
class TicketCompleteRequested extends TicketEvent {
  final String ticketId;
  final CompleteTicketRequest request;

  const TicketCompleteRequested(this.ticketId, this.request);

  @override
  List<Object?> get props => [ticketId, request];
}

/// Event to filter tickets
class TicketFilterChanged extends TicketEvent {
  final TicketStatus? status;
  final TicketCategory? category;
  final String? search;

  const TicketFilterChanged({
    this.status,
    this.category,
    this.search,
  });

  @override
  List<Object?> get props => [status, category, search];
}

/// Event to refresh tickets
class TicketRefreshRequested extends TicketEvent {
  const TicketRefreshRequested();
}

/// Event to load technicians for matching
class TechnicianLoadRequested extends TicketEvent {
  final TicketCategory? category;
  final String? subCategory;
  final Region? region;

  const TechnicianLoadRequested({
    this.category,
    this.subCategory,
    this.region,
  });

  @override
  List<Object?> get props => [category, subCategory, region];
}