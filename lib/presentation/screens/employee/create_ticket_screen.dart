/// Create ticket screen for employees
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/ticket_model.dart';
import '../../../data/models/user_model.dart';
import '../../blocs/ticket/ticket_bloc.dart';
import '../../blocs/ticket/ticket_event.dart';
import '../../blocs/ticket/ticket_state.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/ticket/technician_selector.dart';

/// Screen for creating a new ticket
class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  
  TicketCategory? _selectedCategory;
  String? _selectedSubCategory;
  TechnicianModel? _selectedTechnician;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kategori terlebih dahulu')),
      );
      return;
    }

    if (_selectedTechnician == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih teknisi terlebih dahulu')),
      );
      return;
    }

    final request = CreateTicketRequest(
      deskripsi: _descriptionController.text.trim(),
      kategori: _selectedCategory!,
      subKategori: _selectedSubCategory,
      technicianId: _selectedTechnician!.id,
    );

    context.read<TicketBloc>().add(TicketCreateRequested(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Tiket Baru'),
      ),
      body: BlocConsumer<TicketBloc, TicketState>(
        listener: (context, state) {
          if (state is TicketCreated) {
            Navigator.of(context).pop();
          } else if (state is TicketError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isCreating = state is TicketCreating;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Description field
                  TextFormField(
                    controller: _descriptionController,
                    enabled: !isCreating,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi Masalah *',
                      hintText: 'Jelaskan masalah yang Anda alami secara detail',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    maxLength: AppConstants.maxDescriptionLength,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      if (value.trim().length < AppConstants.minDescriptionLength) {
                        return 'Deskripsi minimal ${AppConstants.minDescriptionLength} karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Category selection
                  Text(
                    'Kategori Masalah *',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<TicketCategory>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      hintText: 'Pilih kategori',
                      prefixIcon: Icon(Icons.category),
                    ),
                    isExpanded: true,
                    items: TicketCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.displayName),
                      );
                    }).toList(),
                    onChanged: isCreating
                        ? null
                        : (value) {
                            setState(() {
                              _selectedCategory = value;
                              _selectedSubCategory = null;
                              _selectedTechnician = null;
                            });
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih kategori terlebih dahulu';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Sub-category for Aplikasi
                  if (_selectedCategory == TicketCategory.aplikasi) ...[
                    Text(
                      'Sub-Kategori',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedSubCategory,
                      decoration: const InputDecoration(
                        hintText: 'Pilih sub-kategori (opsional)',
                        prefixIcon: Icon(Icons.subdirectory_arrow_right),
                      ),
                      isExpanded: true,
                      items: AppSubCategory.values.map((sub) {
                        return DropdownMenuItem(
                          value: sub.displayName,
                          child: Text(sub.displayName),
                        );
                      }).toList(),
                      onChanged: isCreating
                          ? null
                          : (value) {
                              setState(() {
                                _selectedSubCategory = value;
                                _selectedTechnician = null;
                              });
                            },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Sub-category for Akun
                  if (_selectedCategory == TicketCategory.akun) ...[
                    Text(
                      'Sub-Kategori',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedSubCategory,
                      decoration: const InputDecoration(
                        hintText: 'Pilih sub-kategori (opsional)',
                        prefixIcon: Icon(Icons.subdirectory_arrow_right),
                      ),
                      isExpanded: true,
                      items: AccountSubCategory.values.map((sub) {
                        return DropdownMenuItem(
                          value: sub.displayName,
                          child: Text(sub.displayName),
                        );
                      }).toList(),
                      onChanged: isCreating
                          ? null
                          : (value) {
                              setState(() {
                                _selectedSubCategory = value;
                                _selectedTechnician = null;
                              });
                            },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Technician selector
                  if (_selectedCategory != null) ...[
                    TechnicianSelector(
                      category: _selectedCategory!,
                      subCategory: _selectedSubCategory,
                      selectedTechnician: _selectedTechnician,
                      onTechnicianSelected: isCreating
                          ? null
                          : (technician) {
                              setState(() {
                                _selectedTechnician = technician;
                              });
                            },
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Submit button
                  AppButton(
                    text: 'Buat Tiket',
                    onPressed: isCreating ? null : _handleSubmit,
                    isLoading: isCreating,
                    icon: Icons.send,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}