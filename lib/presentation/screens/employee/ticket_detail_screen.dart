/// Employee ticket detail screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/dependency_injection.dart';
import '../../../data/models/ticket_model.dart';
import '../../blocs/comment/comment_bloc.dart';
import '../../blocs/comment/comment_event.dart';
import '../../blocs/ticket/ticket_bloc.dart';
import '../../blocs/ticket/ticket_event.dart';
import '../../blocs/ticket/ticket_state.dart';
import '../../widgets/comment/comment_list.dart';
import '../../widgets/common/error_message.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/ticket/ticket_status_chip.dart';
import '../../widgets/ticket/time_elapsed_widget.dart';

/// Screen showing detailed information about a ticket
class TicketDetailScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailScreen({
    required this.ticketId,
    super.key,
  });

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadTicketDetail();
  }

  void _loadTicketDetail() {
    context.read<TicketBloc>().add(
          TicketDetailLoadRequested(widget.ticketId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DependencyInjection.createCommentBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Tiket'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Text(
                'Geser ke bawah untuk melihat komentar',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: _loadTicketDetail,
            ),
          ],
        ),
        body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          if (state is TicketDetailLoading) {
            return const LoadingIndicator(message: 'Memuat detail tiket...');
          }

          if (state is TicketError) {
            return ErrorMessage(
              message: state.message,
              onRetry: _loadTicketDetail,
            );
          }

          if (state is TicketDetailLoaded) {
            return _buildTicketDetail(context, state.ticket);
          }

          return const Center(child: Text('Tidak ada data'));
        },
        ),
      ),
    );
  }

  Widget _buildTicketDetail(BuildContext context, TicketModel ticket) {
    return Column(
      children: [
        // Ticket information (scrollable)
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              _loadTicketDetail();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // Status and time
            Row(
              children: [
                TicketStatusChip(status: ticket.status),
                const Spacer(),
                TimeElapsedWidget(ticket: ticket),
              ],
            ),
            const SizedBox(height: 24),

            // Ticket ID
            _buildInfoCard(
              context,
              'ID Tiket',
              ticket.id,
              icon: Icons.tag,
            ),
            const SizedBox(height: 16),

            // Description
            _buildInfoCard(
              context,
              'Deskripsi Masalah',
              ticket.deskripsi,
              icon: Icons.description,
              isLarge: true,
            ),
            const SizedBox(height: 16),

            // Category
            _buildInfoCard(
              context,
              'Kategori',
              ticket.kategori.displayName +
                  (ticket.subKategori != null ? ' - ${ticket.subKategori}' : ''),
              icon: Icons.category,
            ),
            const SizedBox(height: 16),

            // Employee info
            _buildInfoCard(
              context,
              'Pelapor',
              '${ticket.employeeNama ?? 'Unknown'}\nNIP: ${ticket.employeeNip ?? '-'}',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),

            // Technician info
            _buildInfoCard(
              context,
              'Teknisi',
              ticket.technicianNama ?? 'Belum ditugaskan',
              icon: Icons.engineering,
            ),
            const SizedBox(height: 16),

            // Timestamps
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Timeline',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildTimelineItem(
                      context,
                      'Dibuat',
                      ticket.createdAt,
                    ),
                    if (ticket.acceptedAt != null)
                      _buildTimelineItem(
                        context,
                        'Diterima Teknisi',
                        ticket.acceptedAt!,
                      ),
                    if (ticket.completedAt != null)
                      _buildTimelineItem(
                        context,
                        'Diselesaikan',
                        ticket.completedAt!,
                      ),
                  ],
                ),
              ),
            ),

            // Resolution notes (if completed)
            if (ticket.resolutionNotes != null) ...[
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                'Catatan Penyelesaian',
                ticket.resolutionNotes!,
                icon: Icons.check_circle,
                isLarge: true,
                color: Colors.green,
              ),
            ],

                ],
              ),
            ),
          ),
        ),
        
        // Comments section (fixed at bottom)
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: CommentList(ticketId: ticket.id),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    bool isLarge = false,
    Color? color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: isLarge
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String label,
    DateTime timestamp,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  _formatDateTime(timestamp),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Today
      return 'Hari ini, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Kemarin, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      // Older
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}