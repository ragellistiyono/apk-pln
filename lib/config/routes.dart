/// App routing configuration
library;

import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/employee/employee_home_screen.dart';
import '../presentation/screens/technician/technician_home_screen.dart';
// Import other screens as they are created
// import '../presentation/screens/admin/admin_home_screen.dart';

/// Route names
class Routes {
  Routes._(); // Private constructor

  // Auth routes
  static const String login = '/login';
  static const String splash = '/';

  // Employee routes
  static const String employeeHome = '/employee/home';
  static const String employeeTickets = '/employee/tickets';
  static const String employeeCreateTicket = '/employee/create-ticket';
  static const String employeeTicketDetail = '/employee/ticket';

  // Technician routes
  static const String technicianHome = '/technician/home';
  static const String technicianQueue = '/technician/queue';
  static const String technicianTicketDetail = '/technician/ticket';

  // Admin routes
  static const String adminHome = '/admin/home';
  static const String adminEmployees = '/admin/employees';
  static const String adminTechnicians = '/admin/technicians';

  // Common routes
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

/// Route generator for named routes
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case Routes.splash:
        // For now, redirect to login
        // TODO: Create splash screen with auth check
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      // Employee routes
      case Routes.employeeHome:
        return MaterialPageRoute(
          builder: (_) => const EmployeeHomeScreen(),
          settings: settings,
        );

      // Technician routes
      case Routes.technicianHome:
        return MaterialPageRoute(
          builder: (_) => const TechnicianHomeScreen(),
          settings: settings,
        );

      // TODO: Add other routes as screens are created

      default:
        return MaterialPageRoute(
          builder: (_) => _ErrorScreen(
            routeName: settings.name ?? 'unknown',
          ),
          settings: settings,
        );
    }
  }

  /// Get initial route based on user role
  static String getInitialRouteForRole(UserRole? role) {
    if (role == null) return Routes.login;

    switch (role) {
      case UserRole.employee:
        return Routes.employeeHome;
      case UserRole.technician:
        return Routes.technicianHome;
      case UserRole.admin:
        return Routes.adminHome;
    }
  }
}

/// Error screen for unknown routes
class _ErrorScreen extends StatelessWidget {
  final String routeName;

  const _ErrorScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Halaman tidak ditemukan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Route: $routeName',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Routes.login);
              },
              icon: const Icon(Icons.home),
              label: const Text('Kembali ke Login'),
            ),
          ],
        ),
      ),
    );
  }
}