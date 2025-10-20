/// Ticket status chip widget
library;

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

/// Chip displaying ticket status with color coding
class TicketStatusChip extends StatelessWidget {
  final TicketStatus status;

  const TicketStatusChip({
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(_getStatusText()),
      backgroundColor: _getStatusColor().withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: _getStatusColor(),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
    );
  }

  Color _getStatusColor() {
    return AppTheme.getStatusColor(status.name);
  }

  String _getStatusText() {
    switch (status) {
      case TicketStatus.pending:
        return 'Menunggu';
      case TicketStatus.inProgress:
        return 'Sedang Dikerjakan';
      case TicketStatus.completed:
        return 'Selesai';
    }
  }
}