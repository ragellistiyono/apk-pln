/// Employee ticket list screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../blocs/ticket/ticket_bloc.dart';
import '../../blocs/ticket/ticket_event.dart';
import '../../blocs/ticket/ticket_state.dart';
import '../../widgets/common/error_message.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/ticket/ticket_card.dart';
import 'create_ticket_screen.dart';
import 'ticket_detail_screen.dart';

/// Screen showing list of employee's tickets
class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  TicketStatus? _selectedStatus;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load tickets on init
    context.read<TicketBloc>().add(const TicketLoadRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TicketBloc>().add(const TicketLoadMoreRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiket Saya'),
        actions: [
          PopupMenuButton<TicketStatus?>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Status',
            onSelected: (status) {
              setState(() {
                _selectedStatus = status;
              });
              context.read<TicketBloc>().add(
                    TicketFilterChanged(status: status),
                  );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Semua Status'),
              ),
              PopupMenuItem(
                value: TicketStatus.pending,
                child: Text(TicketStatus.pending.displayName),
              ),
              PopupMenuItem(
                value: TicketStatus.inProgress,
                child: Text(TicketStatus.inProgress.displayName),
              ),
              PopupMenuItem(
                value: TicketStatus.completed,
                child: Text(TicketStatus.completed.displayName),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              context.read<TicketBloc>().add(const TicketRefreshRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<TicketBloc, TicketState>(
        listener: (context, state) {
          if (state is TicketCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppConstants.successTicketCreated),
                backgroundColor: Colors.green,
              ),
            );
            // Reload tickets after creation
            context.read<TicketBloc>().add(const TicketRefreshRequested());
          }
        },
        builder: (context, state) {
          if (state is TicketLoading) {
            return const LoadingIndicator(message: 'Memuat tiket...');
          }

          if (state is TicketError) {
            return ErrorMessage(
              message: state.message,
              onRetry: () {
                context.read<TicketBloc>().add(const TicketRefreshRequested());
              },
            );
          }

          if (state is TicketLoaded) {
            if (state.tickets.isEmpty) {
              return EmptyState(
                message: _selectedStatus == null
                    ? 'Anda belum memiliki tiket'
                    : 'Tidak ada tiket dengan status ${_selectedStatus!.displayName}',
                icon: Icons.inbox_outlined,
                action: ElevatedButton.icon(
                  onPressed: () => _navigateToCreateTicket(),
                  icon: const Icon(Icons.add),
                  label: const Text('Buat Tiket Baru'),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TicketBloc>().add(const TicketRefreshRequested());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.tickets.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.tickets.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: SmallLoadingIndicator()),
                    );
                  }

                  final ticket = state.tickets[index];
                  return TicketCard(
                    ticket: ticket,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<TicketBloc>(),
                            child: TicketDetailScreen(ticketId: ticket.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const Center(child: Text('State tidak dikenal'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateTicket,
        icon: const Icon(Icons.add),
        label: const Text('Buat Tiket'),
      ),
    );
  }

  void _navigateToCreateTicket() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TicketBloc>(),
          child: const CreateTicketScreen(),
        ),
      ),
    );
  }
}