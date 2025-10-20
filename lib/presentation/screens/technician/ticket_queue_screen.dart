/// Technician ticket queue screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/ticket/ticket_bloc.dart';
import '../../blocs/ticket/ticket_event.dart';
import '../../blocs/ticket/ticket_state.dart';
import '../../widgets/common/error_message.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/ticket/ticket_card.dart';
import 'ticket_detail_screen.dart';

/// Screen showing technician's assigned tickets
class TicketQueueScreen extends StatefulWidget {
  const TicketQueueScreen({super.key});

  @override
  State<TicketQueueScreen> createState() => _TicketQueueScreenState();
}

class _TicketQueueScreenState extends State<TicketQueueScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    _loadTickets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTickets() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<TicketBloc>().add(
            TicketLoadRequested(
              technicianId: authState.user.id,
            ),
          );
    }
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
        title: const Text('Antrian Tiket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadTickets,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Sedang Dikerjakan'),
          ],
          onTap: (index) {
            final status = index == 0
                ? TicketStatus.pending
                : TicketStatus.inProgress;
            
            final authState = context.read<AuthBloc>().state;
            if (authState is AuthAuthenticated) {
              context.read<TicketBloc>().add(
                    TicketFilterChanged(
                      status: status,
                    ),
                  );
            }
          },
        ),
      ),
      body: BlocConsumer<TicketBloc, TicketState>(
        listener: (context, state) {
          if (state is TicketAccepted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppConstants.successTicketAccepted),
                backgroundColor: Colors.green,
              ),
            );
            _loadTickets();
          } else if (state is TicketCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppConstants.successTicketCompleted),
                backgroundColor: Colors.green,
              ),
            );
            _loadTickets();
          }
        },
        builder: (context, state) {
          if (state is TicketLoading) {
            return const LoadingIndicator(message: 'Memuat tiket...');
          }

          if (state is TicketError) {
            return ErrorMessage(
              message: state.message,
              onRetry: _loadTickets,
            );
          }

          if (state is TicketLoaded) {
            if (state.tickets.isEmpty) {
              return EmptyState(
                message: _tabController.index == 0
                    ? 'Tidak ada tiket baru'
                    : 'Tidak ada tiket yang sedang dikerjakan',
                icon: Icons.work_outline,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadTickets();
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
                            child: TechnicianTicketDetailScreen(
                              ticketId: ticket.id,
                            ),
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
    );
  }
}