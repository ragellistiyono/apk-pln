/// Core application constants and enumerations
/// Defines categories, regions, status, and other fixed values
library;

/// Ticket categories available in the system
enum TicketCategory {
  hardware('Hardware'),
  jaringanKoneksi('Jaringan/Koneksi'),
  zoom('Zoom'),
  akun('Akun'),
  aplikasi('Aplikasi');

  const TicketCategory(this.displayName);
  final String displayName;

  /// Get category from string value
  static TicketCategory? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'hardware':
        return TicketCategory.hardware;
      case 'jaringan/koneksi':
      case 'jaringan':
        return TicketCategory.jaringanKoneksi;
      case 'zoom':
        return TicketCategory.zoom;
      case 'akun':
        return TicketCategory.akun;
      case 'aplikasi':
        return TicketCategory.aplikasi;
      default:
        return null;
    }
  }
}

/// Sub-categories for applications
enum AppSubCategory {
  sap('SAP'),
  minerium('Minerium'),
  smartness('Smartness'),
  lainnya('Lainnya');

  const AppSubCategory(this.displayName);
  final String displayName;
}

/// Sub-categories for accounts
enum AccountSubCategory {
  emailKorporat('Email/Korporat'),
  vpn('VPN');

  const AccountSubCategory(this.displayName);
  final String displayName;
}

/// Employee/Technician regions
enum Region {
  kantorInduk('Kantor Induk UIT JBM'),
  uptSurabaya('UPT Surabaya'),
  uptMalang('UPT Malang'),
  uptMadiun('UPT Madiun'),
  uptProbolinggo('UPT Probolinggo'),
  uptGresik('UPT Gresik'),
  uptBali('UPT Bali'),
  allUit('ALL UIT');

  const Region(this.displayName);
  final String displayName;

  /// Check if this is a regional assignment (not ALL UIT)
  bool get isRegional => this != Region.allUit;

  /// Get region from string value
  static Region? fromString(String value) {
    switch (value.toLowerCase().replaceAll(' ', '')) {
      case 'kantorindukuitjbm':
      case 'kantorinduk':
        return Region.kantorInduk;
      case 'uptsurabaya':
      case 'surabaya':
        return Region.uptSurabaya;
      case 'uptmalang':
      case 'malang':
        return Region.uptMalang;
      case 'uptmadiun':
      case 'madiun':
        return Region.uptMadiun;
      case 'uptprobolinggo':
      case 'probolinggo':
        return Region.uptProbolinggo;
      case 'uptgresik':
      case 'gresik':
        return Region.uptGresik;
      case 'uptbali':
      case 'bali':
        return Region.uptBali;
      case 'alluit':
      case 'all':
        return Region.allUit;
      default:
        return null;
    }
  }
}

/// Ticket status
enum TicketStatus {
  pending('Pending'),
  inProgress('In Progress'),
  completed('Completed');

  const TicketStatus(this.displayName);
  final String displayName;

  /// Get status from string value
  static TicketStatus? fromString(String value) {
    switch (value.toLowerCase().replaceAll(' ', '').replaceAll('_', '')) {
      case 'pending':
        return TicketStatus.pending;
      case 'inprogress':
        return TicketStatus.inProgress;
      case 'completed':
        return TicketStatus.completed;
      default:
        return null;
    }
  }
}

/// User roles in the system
enum UserRole {
  employee('Employee'),
  technician('Technician'),
  admin('Admin');

  const UserRole(this.displayName);
  final String displayName;

  /// Get role from string value
  static UserRole? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'employee':
        return UserRole.employee;
      case 'technician':
        return UserRole.technician;
      case 'admin':
        return UserRole.admin;
      default:
        return null;
    }
  }
}

/// Application-wide constants
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // App Information
  static const String appName = 'PLN Ticket System';
  static const String appVersion = '1.0.0';

  // Validation Constants
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 500;
  static const int minNipLength = 6;
  static const int maxNipLength = 10;
  static const int minPasswordLength = 6;

  // Pagination
  static const int ticketsPerPage = 20;
  static const int commentsPerPage = 50;

  // Time Constants (in seconds)
  static const int notificationTimeout = 5;
  static const int apiTimeout = 30;
  static const int retryDelay = 3;
  static const int maxRetries = 3;

  // Real-time Update Intervals (in seconds)
  static const int timeElapsedUpdateInterval = 60;
  static const int notificationPollInterval = 10;
  static const int ticketRefreshInterval = 30;

  // WebSocket
  static const int websocketReconnectDelay = 5;
  static const int websocketPingInterval = 30;

  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyRefreshToken = 'refresh_token';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyUserRole = 'user_role';
  static const String storageKeyThemeMode = 'theme_mode';

  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd MMM yyyy, HH:mm';
  static const String isoDateFormat = 'yyyy-MM-ddTHH:mm:ss';

  // Error Messages
  static const String errorNetwork = 'Koneksi jaringan bermasalah';
  static const String errorServer = 'Server tidak merespons';
  static const String errorAuth = 'Sesi telah berakhir, silakan login kembali';
  static const String errorUnknown = 'Terjadi kesalahan, silakan coba lagi';
  static const String errorValidation = 'Data tidak valid';

  // Success Messages
  static const String successTicketCreated = 'Tiket berhasil dibuat';
  static const String successTicketAccepted = 'Tiket berhasil diterima';
  static const String successTicketCompleted = 'Tiket berhasil diselesaikan';
  static const String successCommentAdded = 'Komentar berhasil ditambahkan';
}