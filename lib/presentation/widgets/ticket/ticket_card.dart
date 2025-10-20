/// Ticket card widget for displaying tickets in lists
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/ticket_model.dart';
import 'ticket_status_chip.dart';
import 'time_elapsed_widget.dart';

/// Card widget for displaying ticket in list
class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback? onTap;

  const TicketCard({
    required this.ticket,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with status and time
              Row(
                children: [
                  TicketStatusChip(status: ticket.status),
                  const Spacer(),
                  TimeElapsedWidget(ticket: ticket),
                ],
              ),
              const SizedBox(height: 12),

              // Ticket description
              Text(
                ticket.deskripsi,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Category chip
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(ticket.kategori.displayName),
                    backgroundColor: AppTheme.getCategoryColor(
                      ticket.kategori.displayName,
                    ).withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: AppTheme.getCategoryColor(
                        ticket.kategori.displayName,
                      ),
                      fontSize: 12,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  if (ticket.subKategori != null)
                    Chip(
                      label: Text(ticket.subKategori!),
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: const TextStyle(fontSize: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Technician info
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      ticket.technicianNama ?? 'Belum ditugaskan',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (ticket.commentCount != null && ticket.commentCount! > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.comment_outlined, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${ticket.commentCount}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}