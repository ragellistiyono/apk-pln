/// Widget tests for PLN Ticket System
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apk_pln/main.dart';

void main() {
  testWidgets('App starts and shows login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const PLNTicketApp());

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify that login screen elements are present
    expect(find.text('PLN Ticket System'), findsOneWidget);
    expect(find.text('Sistem Tiket Internal PLN'), findsOneWidget);
    expect(find.text('Username/NIP'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
