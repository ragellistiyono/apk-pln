/// Employee home screen with bottom navigation
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import 'ticket_list_screen.dart';

/// Employee home screen with bottom navigation
class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TicketListScreen(),
    _NotificationsPlaceholder(),
    _ProfilePlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Tiket Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

/// Placeholder for notifications screen
class _NotificationsPlaceholder extends StatelessWidget {
  const _NotificationsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_outlined, size: 64),
            SizedBox(height: 16),
            Text('Notifikasi akan ditambahkan di User Story 5'),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for profile screen
class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 64),
            const SizedBox(height: 16),
            const Text('Profil Pengguna'),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}