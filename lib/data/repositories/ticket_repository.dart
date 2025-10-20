/// Ticket repository for managing ticket operations
library;

import 'package:logger/logger.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../datasources/remote/api_client.dart';
import '../models/ticket_model.dart';
import '../models/user_model.dart';

/// Repository for ticket operations
class TicketRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  TicketRepository(this._apiClient);

  /// Create a new ticket
  Future<TicketModel> createTicket(CreateTicketRequest request) async {
    try {
      _logger.d('Creating ticket: ${request.kategori.displayName}');

      final response = await _apiClient.post(
        ApiConstants.tickets,
        data: request.toJson(),
      );

      final ticket = TicketModel.fromJson(
        response.data[ApiConstants.keyData],
      );

      _logger.i('Ticket created successfully: ${ticket.id}');
      return ticket;
    } catch (e) {
      _logger.e('Failed to create ticket: $e');
      rethrow;
    }
  }

  /// Get tickets with optional filtering
  Future<TicketListResponse> getTickets({
    int page = 1,
    int limit = 20,
    TicketStatus? status,
    TicketCategory? category,
    String? employeeId,
    String? technicianId,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        ApiConstants.paramPage: page,
        ApiConstants.paramLimit: limit,
      };

      if (status != null) {
        queryParams[ApiConstants.paramStatus] = status.name;
      }
      if (category != null) {
        queryParams[ApiConstants.paramCategory] = category.name;
      }
      if (employeeId != null) {
        queryParams[ApiConstants.paramEmployeeId] = employeeId;
      }
      if (technicianId != null) {
        queryParams[ApiConstants.paramTechnicianId] = technicianId;
      }
      if (search != null && search.isNotEmpty) {
        queryParams[ApiConstants.paramSearch] = search;
      }

      _logger.d('Fetching tickets with params: $queryParams');

      final response = await _apiClient.get(
        ApiConstants.tickets,
        queryParameters: queryParams,
      );

      final ticketList = TicketListResponse.fromJson(
        response.data[ApiConstants.keyData],
      );

      _logger.i('Fetched ${ticketList.tickets.length} tickets');
      return ticketList;
    } catch (e) {
      _logger.e('Failed to fetch tickets: $e');
      rethrow;
    }
  }

  /// Get a single ticket by ID
  Future<TicketModel> getTicketById(String ticketId) async {
    try {
      _logger.d('Fetching ticket: $ticketId');

      final response = await _apiClient.get(
        ApiConstants.ticketById(ticketId),
      );

      final ticket = TicketModel.fromJson(
        response.data[ApiConstants.keyData],
      );

      _logger.i('Ticket fetched: ${ticket.id}');
      return ticket;
    } catch (e) {
      _logger.e('Failed to fetch ticket: $e');
      rethrow;
    }
  }

  /// Accept a ticket (technician only)
  Future<TicketModel> acceptTicket(String ticketId) async {
    try {
      _logger.d('Accepting ticket: $ticketId');

      final response = await _apiClient.post(
        ApiConstants.ticketAccept(ticketId),
      );

      final ticket = TicketModel.fromJson(
        response.data[ApiConstants.keyData],
      );

      _logger.i('Ticket accepted: ${ticket.id}');
      return ticket;
    } catch (e) {
      _logger.e('Failed to accept ticket: $e');
      rethrow;
    }
  }

  /// Complete a ticket (technician only)
  Future<TicketModel> completeTicket(
    String ticketId,
    CompleteTicketRequest request,
  ) async {
    try {
      _logger.d('Completing ticket: $ticketId');

      final response = await _apiClient.post(
        ApiConstants.ticketComplete(ticketId),
        data: request.toJson(),
      );

      final ticket = TicketModel.fromJson(
        response.data[ApiConstants.keyData],
      );

      _logger.i('Ticket completed: ${ticket.id}');
      return ticket;
    } catch (e) {
      _logger.e('Failed to complete ticket: $e');
      rethrow;
    }
  }

  /// Get available technicians for matching
  Future<List<TechnicianModel>> getTechnicians({
    TicketCategory? category,
    String? subCategory,
    Region? region,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (category != null) {
        queryParams[ApiConstants.paramCategory] = category.name;
      }
      if (region != null) {
        queryParams[ApiConstants.paramRegion] = region.name;
      }

      _logger.d('Fetching technicians with params: $queryParams');

      final response = await _apiClient.get(
        ApiConstants.technicians,
        queryParameters: queryParams,
      );

      final techniciansList = (response.data[ApiConstants.keyData] as List)
          .map((json) => TechnicianModel.fromJson(json))
          .toList();

      _logger.i('Fetched ${techniciansList.length} technicians');
      return techniciansList;
    } catch (e) {
      _logger.e('Failed to fetch technicians: $e');
      rethrow;
    }
  }
}