/// Technician ticket detail screen with accept/complete actions
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/ticket_model.dart';
import '../../blocs/ticket/ticket_bloc.dart';
import '../../blocs/ticket/ticket_event.dart';
import '../../blocs/ticket/ticket_state.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/error_message.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/ticket/ticket_status_chip.dart';
import '../../widgets/ticket/time_elapsed_widget.dart';

/// Screen showing ticket detail for technician with action buttons
class TechnicianTicketDetailScreen extends StatefulWidget {
  final String ticketId;

  const TechnicianTicketDetailScreen({
    required this.ticketId,
    super.key,
  });

  @override
  State<TechnicianTicketDetailScreen> createState() =>
      _TechnicianTicketDetailScreenState();
}

class _TechnicianTicketDetailScreenState
    extends State<TechnicianTicketDetailScreen> {
  final _resolutionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTicketDetail();
  }

  @override
  void dispose() {
    _resolutionController.dispose();
    super.dispose();
  }

  void _loadTicketDetail() {
    context.read<TicketBloc>().add(
          TicketDetailLoadRequested(widget.ticketId),
        );
  }

  void _handleAccept(TicketModel ticket) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Terima Tiket'),
        content: const Text(
          'Anda yakin ingin menerima tiket ini?\n\nStatus akan berubah menjadi "Sedang Dikerjakan".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<TicketBloc>().add(
                    TicketAcceptRequested(ticket.id),
                  );
            },
            child: const Text('Terima'),
          ),
        ],
      ),
    );
  }

  void _handleComplete(TicketModel ticket) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Selesaikan Tiket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Tambahkan catatan penyelesaian:'),
            const SizedBox(height: 16),
            TextField(
              controller: _resolutionController,
              decoration: const InputDecoration(
                hintText: 'Masalah telah diselesaikan dengan...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              maxLength: 500,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_resolutionController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Catatan penyelesaian tidak boleh kosong'),
                  ),
                );
                return;
              }

              Navigator.pop(dialogContext);
              context.read<TicketBloc>().add(
                    TicketCompleteRequested(
                      ticket.id,
                      CompleteTicketRequest(
                        resolutionNotes: _resolutionController.text.trim(),
                      ),
                    ),
                  );
            },
            child: const Text('Selesaikan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tiket'),
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

          if (state is TicketAccepting) {
            return const LoadingIndicator(message: 'Menerima tiket...');
          }

          if (state is TicketCompleting) {
            return const LoadingIndicator(message: 'Menyelesaikan tiket...');
          }

          return const Center(child: Text('Tidak ada data'));
        },
      ),
    );
  }

  Widget _buildTicketDetail(BuildContext context, TicketModel ticket) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadTicketDetail();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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

            // Employee info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Pelapor',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Text(
                      ticket.employeeNama ?? 'Unknown',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'NIP: ${ticket.employeeNip ?? '-'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.category, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Kategori',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Text(
                      ticket.kategori.displayName +
                          (ticket.subKategori != null
                              ? ' - ${ticket.subKategori}'
                              : ''),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.description, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Deskripsi Masalah',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Text(
                      ticket.deskripsi,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Resolution notes (if completed)
            if (ticket.resolutionNotes != null) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, size: 20, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Catatan Penyelesaian',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.green.shade700,
                                ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Text(
                        ticket.resolutionNotes!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action buttons
            if (ticket.isPending) ...[
              const SizedBox(height: 16),
              AppButton(
                text: 'Terima Tiket',
                onPressed: () => _handleAccept(ticket),
                icon: Icons.check,
              ),
            ],

            if (ticket.isInProgress) ...[
              const SizedBox(height: 16),
              AppButton(
                text: 'Selesaikan Tiket',
                onPressed: () => _handleComplete(ticket),
                icon: Icons.done_all,
              ),
            ],
          ],
        ),
      ),
    );
  }
}