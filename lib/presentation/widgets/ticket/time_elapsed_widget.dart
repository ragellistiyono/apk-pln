/// Time elapsed widget for tickets
library;

import 'package:flutter/material.dart';
import '../../../data/models/ticket_model.dart';

/// Widget displaying time elapsed since ticket creation
class TimeElapsedWidget extends StatelessWidget {
  final TicketModel ticket;
  final bool showIcon;

  const TimeElapsedWidget({
    required this.ticket,
    this.showIcon = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            Icons.access_time,
            size: 14,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          ticket.getFormattedElapsedTime(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }
}