/// Ticket states
library;

import 'package:equatable/equatable.dart';
import '../../../data/models/ticket_model.dart';
import '../../../data/models/user_model.dart';

/// Base class for ticket states
abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TicketInitial extends TicketState {
  const TicketInitial();
}

/// Loading tickets
class TicketLoading extends TicketState {
  const TicketLoading();
}

/// Tickets loaded successfully
class TicketLoaded extends TicketState {
  final List<TicketModel> tickets;
  final int total;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const TicketLoaded({
    required this.tickets,
    required this.total,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [tickets, total, currentPage, hasMore, isLoadingMore];

  TicketLoaded copyWith({
    List<TicketModel>? tickets,
    int? total,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return TicketLoaded(
      tickets: tickets ?? this.tickets,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Error loading tickets
class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Single ticket detail loaded
class TicketDetailLoaded extends TicketState {
  final TicketModel ticket;

  const TicketDetailLoaded(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

/// Loading ticket detail
class TicketDetailLoading extends TicketState {
  const TicketDetailLoading();
}

/// Ticket created successfully
class TicketCreated extends TicketState {
  final TicketModel ticket;

  const TicketCreated(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

/// Creating ticket
class TicketCreating extends TicketState {
  const TicketCreating();
}

/// Ticket accepted successfully
class TicketAccepted extends TicketState {
  final TicketModel ticket;

  const TicketAccepted(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

/// Accepting ticket
class TicketAccepting extends TicketState {
  const TicketAccepting();
}

/// Ticket completed successfully
class TicketCompleted extends TicketState {
  final TicketModel ticket;

  const TicketCompleted(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

/// Completing ticket
class TicketCompleting extends TicketState {
  const TicketCompleting();
}

/// Technicians loaded for matching
class TechnicianLoaded extends TicketState {
  final List<TechnicianModel> technicians;

  const TechnicianLoaded(this.technicians);

  @override
  List<Object?> get props => [technicians];
}

/// Loading technicians
class TechnicianLoading extends TicketState {
  const TechnicianLoading();
}