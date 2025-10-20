/// Main entry point for PLN Ticket System
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/dependency_injection.dart';
import 'config/routes.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await DependencyInjection.init();

  runApp(const PLNTicketApp());
}

/// Root application widget
class PLNTicketApp extends StatelessWidget {
  const PLNTicketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.providers,
      child: const PLNTicketMaterialApp(),
    );
  }
}

/// Material App wrapper with routing
class PLNTicketMaterialApp extends StatelessWidget {
  const PLNTicketMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // Initial route depends on auth status
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Show loading while checking auth
          if (state is AuthChecking || state is AuthInitial) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // If authenticated, navigate based on user role
          if (state is AuthAuthenticated) {
            final initialRoute = AppRouter.getInitialRouteForRole(
              state.user.role,
            );
            
            return Navigator(
              onGenerateRoute: AppRouter.generateRoute,
              initialRoute: initialRoute,
            );
          }

          // Default: show login screen
          return Navigator(
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: Routes.login,
          );
        },
      ),
      
      // Route configuration
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: Routes.splash,
    );
  }
}
