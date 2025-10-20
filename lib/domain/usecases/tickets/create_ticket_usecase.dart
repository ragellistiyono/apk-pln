/// Use case for creating a ticket
library;

import '../../../data/models/ticket_model.dart';
import '../../../data/repositories/ticket_repository.dart';

/// Use case for creating a new ticket
class CreateTicketUseCase {
  final TicketRepository _repository;

  CreateTicketUseCase(this._repository);

  /// Execute the use case
  /// Returns created TicketModel on success
  /// Throws exception on failure
  Future<TicketModel> execute(CreateTicketRequest request) async {
    // Validate request
    if (request.deskripsi.isEmpty || request.deskripsi.length < 10) {
      throw ValidationException(
        'Deskripsi tiket minimal 10 karakter',
      );
    }

    if (request.deskripsi.length > 500) {
      throw ValidationException(
        'Deskripsi tiket maksimal 500 karakter',
      );
    }

    // Create ticket via repository
    return await _repository.createTicket(request);
  }
}

/// Validation exception
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => message;
}