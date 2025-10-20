/// Technician selector widget for ticket creation
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/user_model.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/ticket/ticket_bloc.dart';
import '../../blocs/ticket/ticket_event.dart';
import '../../blocs/ticket/ticket_state.dart';
import '../common/loading_indicator.dart';

/// Widget for selecting a technician based on ticket criteria
class TechnicianSelector extends StatefulWidget {
  final TicketCategory category;
  final String? subCategory;
  final TechnicianModel? selectedTechnician;
  final Function(TechnicianModel)? onTechnicianSelected;

  const TechnicianSelector({
    required this.category,
    this.subCategory,
    this.selectedTechnician,
    this.onTechnicianSelected,
    super.key,
  });

  @override
  State<TechnicianSelector> createState() => _TechnicianSelectorState();
}

class _TechnicianSelectorState extends State<TechnicianSelector> {
  @override
  void initState() {
    super.initState();
    _loadTechnicians();
  }

  @override
  void didUpdateWidget(TechnicianSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category ||
        oldWidget.subCategory != widget.subCategory) {
      _loadTechnicians();
    }
  }

  void _loadTechnicians() {
    // Get employee region from auth state
    final authState = context.read<AuthBloc>().state;
    Region? employeeRegion;

    if (authState is AuthAuthenticated) {
      final user = authState.user;
      if (user is EmployeeModel) {
        employeeRegion = user.region;
      }
    }

    context.read<TicketBloc>().add(
          TechnicianLoadRequested(
            category: widget.category,
            subCategory: widget.subCategory,
            region: employeeRegion,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Teknisi *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        BlocBuilder<TicketBloc, TicketState>(
          builder: (context, state) {
            if (state is TechnicianLoading) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: SmallLoadingIndicator()),
                ),
              );
            }

            if (state is TechnicianLoaded) {
              if (state.technicians.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Tidak ada teknisi yang tersedia untuk kategori ini',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: state.technicians.map((technician) {
                  final isSelected =
                      widget.selectedTechnician?.id == technician.id;

                  return Card(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                        : null,
                    child: InkWell(
                      onTap: widget.onTechnicianSelected != null
                          ? () => widget.onTechnicianSelected!(technician)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Selection indicator
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            const SizedBox(width: 12),

                            // Technician info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    technician.nama,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    technician.wilayah?.displayName ??
                                        'Semua Wilayah',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  if (technician.subCategories.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: technician.subCategories
                                          .map(
                                            (sub) => Chip(
                                              label: Text(sub),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              labelStyle: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}