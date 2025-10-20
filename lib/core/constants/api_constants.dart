/// API endpoint constants and configuration
library;

/// API configuration and endpoints
class ApiConstants {
  ApiConstants._(); // Private constructor

  // Base Configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api';

  // Timeouts (in seconds)
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // Headers
  static const String headerContentType = 'Content-Type';
  static const String headerAuthorization = 'Authorization';
  static const String headerAccept = 'Accept';

  static const String contentTypeJson = 'application/json';
  static const String authTypeBearer = 'Bearer';

  // Authentication Endpoints
  static const String authLogin = '$apiPrefix/auth/login';
  static const String authRefresh = '$apiPrefix/auth/refresh';
  static const String authLogout = '$apiPrefix/auth/logout';

  // Ticket Endpoints
  static const String tickets = '$apiPrefix/tickets';
  static String ticketById(String id) => '$tickets/$id';
  static String ticketAccept(String id) => '$tickets/$id/accept';
  static String ticketComplete(String id) => '$tickets/$id/complete';
  static String ticketComments(String id) => '$tickets/$id/comments';

  // Comment Endpoints
  static const String comments = '$apiPrefix/comments';
  static String commentById(String id) => '$comments/$id';

  // Technician Endpoints
  static const String technicians = '$apiPrefix/technicians';
  static String technicianById(String id) => '$technicians/$id';

  // Notification Endpoints
  static const String notifications = '$apiPrefix/notifications';
  static String notificationById(String id) => '$notifications/$id';
  static String notificationMarkRead(String id) => '$notifications/$id/read';

  // Admin Endpoints
  static const String employees = '$apiPrefix/employees';
  static String employeeById(String id) => '$employees/$id';

  static const String adminTechnicians = '$apiPrefix/admin/technicians';
  static String adminTechnicianById(String id) => '$adminTechnicians/$id';

  // Statistics Endpoints
  static const String ticketStats = '$apiPrefix/tickets/stats';

  // Health Check
  static const String health = '$apiPrefix/health';

  // WebSocket Configuration
  static String get wsBaseUrl {
    final uri = Uri.parse(baseUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    return '$wsScheme://${uri.host}:${uri.port}';
  }

  static const String wsPath = '/ws';
  static String wsNotifications(String userId) => '$wsPath/notifications/$userId';
  static String wsTickets(String userId) => '$wsPath/tickets/$userId';

  // Query Parameters
  static const String paramPage = 'page';
  static const String paramLimit = 'limit';
  static const String paramStatus = 'status';
  static const String paramCategory = 'category';
  static const String paramRegion = 'region';
  static const String paramSearch = 'search';
  static const String paramStartDate = 'start_date';
  static const String paramEndDate = 'end_date';
  static const String paramEmployeeId = 'employee_id';
  static const String paramTechnicianId = 'technician_id';

  // HTTP Status Codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusConflict = 409;
  static const int statusInternalServerError = 500;
  static const int statusServiceUnavailable = 503;

  // Error Codes (from backend)
  static const String errorCodeInvalidCredentials = 'INVALID_CREDENTIALS';
  static const String errorCodeTokenExpired = 'TOKEN_EXPIRED';
  static const String errorCodeTokenInvalid = 'TOKEN_INVALID';
  static const String errorCodeNotFound = 'NOT_FOUND';
  static const String errorCodeValidation = 'VALIDATION_ERROR';
  static const String errorCodeConflict = 'CONFLICT';
  static const String errorCodeServerError = 'SERVER_ERROR';

  // Request/Response Keys
  static const String keyData = 'data';
  static const String keyError = 'error';
  static const String keyMessage = 'message';
  static const String keyCode = 'code';
  static const String keyToken = 'token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyTickets = 'tickets';
  static const String keyComments = 'comments';
  static const String keyTotal = 'total';
  static const String keyPage = 'page';
  static const String keyLimit = 'limit';
}

/// HTTP Methods
enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete,
}