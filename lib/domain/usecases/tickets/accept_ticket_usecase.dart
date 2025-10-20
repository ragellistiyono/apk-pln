/// Use case for accepting a ticket (technician)
library;

import '../../../data/models/ticket_model.dart';
import '../../../data/repositories/ticket_repository.dart';

/// Use case for technician accepting a ticket
class AcceptTicketUseCase {
  final TicketRepository _repository;

  AcceptTicketUseCase(this._repository);

  /// Execute the use case
  /// Returns updated TicketModel on success
  Future<TicketModel> execute(String ticketId) async {
    if (ticketId.isEmpty) {
      throw ValidationException('ID tiket tidak valid');
    }

    return await _repository.acceptTicket(ticketId);
  }
}

/// Use case for completing a ticket
class CompleteTicketUseCase {
  final TicketRepository _repository;

  CompleteTicketUseCase(this._repository);

  /// Execute the use case
  /// Returns completed TicketModel on success
  Future<TicketModel> execute(
    String ticketId,
    String resolutionNotes,
  ) async {
    if (ticketId.isEmpty) {
      throw ValidationException('ID tiket tidak valid');
    }

    if (resolutionNotes.trim().isEmpty) {
      throw ValidationException(
        'Catatan penyelesaian tidak boleh kosong',
      );
    }

    if (resolutionNotes.trim().length < 10) {
      throw ValidationException(
        'Catatan penyelesaian minimal 10 karakter',
      );
    }

    final request = CompleteTicketRequest(
      resolutionNotes: resolutionNotes.trim(),
    );

    return await _repository.completeTicket(ticketId, request);
  }
}

/// Validation exception
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => message;
}