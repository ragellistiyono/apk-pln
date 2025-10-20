/// Use case for fetching tickets
library;

import '../../../core/constants/app_constants.dart';
import '../../../data/models/ticket_model.dart';
import '../../../data/repositories/ticket_repository.dart';

/// Use case for getting tickets with filtering
class GetTicketsUseCase {
  final TicketRepository _repository;

  GetTicketsUseCase(this._repository);

  /// Execute the use case
  /// Returns TicketListResponse with paginated tickets
  Future<TicketListResponse> execute({
    int page = 1,
    int? limit,
    TicketStatus? status,
    TicketCategory? category,
    String? employeeId,
    String? technicianId,
    String? search,
  }) async {
    final effectiveLimit = limit ?? AppConstants.ticketsPerPage;

    // Validate page number
    if (page < 1) {
      throw const ValidationException('Halaman harus lebih dari 0');
    }

    // Fetch tickets via repository
    return await _repository.getTickets(
      page: page,
      limit: effectiveLimit,
      status: status,
      category: category,
      employeeId: employeeId,
      technicianId: technicianId,
      search: search,
    );
  }
}

/// Use case for getting a single ticket by ID
class GetTicketByIdUseCase {
  final TicketRepository _repository;

  GetTicketByIdUseCase(this._repository);

  /// Execute the use case
  /// Returns TicketModel
  Future<TicketModel> execute(String ticketId) async {
    if (ticketId.isEmpty) {
      throw const ValidationException('ID tiket tidak valid');
    }

    return await _repository.getTicketById(ticketId);
  }
}

/// Validation exception
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => message;
}