import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/admin_plan_list_item_entity.dart';
import '../../domain/entities/admin_branch_option_entity.dart';
import '../../domain/usecases/admin_plans_usecases.dart';
import '../../data/services/admin_plans_remote_service.dart';
import '../../data/repositories/admin_plans_repository_impl.dart';
import '../../data/models/createplanrequestmodel.dart';
import '../../data/models/updateplanrequestmodel.dart';
import '../bloc/plan_form/plan_form_bloc.dart';

/// Call this static method to show the bottom sheet from anywhere.
///
/// Add mode:  PlanFormBottomSheet.show(context, onSuccess: ...)
/// Edit mode: PlanFormBottomSheet.show(context, existingPlan: plan, onSuccess: ...)
class PlanFormBottomSheet {
  static void show(
      BuildContext context, {
        AdminPlanListItemEntity? existingPlan,
        required VoidCallback onSuccess,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // allows the sheet to resize above the keyboard
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider(
        create: (_) => PlanFormBloc(
          getPlanTypes: GetPlanTypesUseCase(
            repository: AdminPlansRepositoryImpl(
              remoteDatasource: AdminPlansRemoteDatasourceImpl(),
            ),
          ),
          getBranches: GetBranchesUseCase(
            repository: AdminPlansRepositoryImpl(
              remoteDatasource: AdminPlansRemoteDatasourceImpl(),
            ),
          ),
          createPlan: CreatePlanUseCase(
            repository: AdminPlansRepositoryImpl(
              remoteDatasource: AdminPlansRemoteDatasourceImpl(),
            ),
          ),
          updatePlan: UpdatePlanUseCase(
            repository: AdminPlansRepositoryImpl(
              remoteDatasource: AdminPlansRemoteDatasourceImpl(),
            ),
          ),
        )..add(LoadFormDataEvent()),
        child: _PlanFormContent(
          existingPlan: existingPlan,
          onSuccess: onSuccess,
        ),
      ),
    );
  }
}

// ── Internal form content ─────────────────────────────────────────────────────

class _PlanFormContent extends StatefulWidget {
  final AdminPlanListItemEntity? existingPlan;
  final VoidCallback onSuccess;

  const _PlanFormContent({this.existingPlan, required this.onSuccess});

  @override
  State<_PlanFormContent> createState() => _PlanFormContentState();
}

class _PlanFormContentState extends State<_PlanFormContent> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _promotionController;

  String? _selectedType;
  String? _selectedBillingCycle;
  String? _selectedStatus;
  int? _selectedBranchId;

  bool get _isEditMode => widget.existingPlan != null;

  static const _billingCycles = ['monthly', 'quarterly', 'yearly', 'one_time'];
  static const _statuses = ['active', 'inactive'];

  @override
  void initState() {
    super.initState();
    final plan = widget.existingPlan;
    _nameController = TextEditingController(text: plan?.name ?? '');
    _priceController =
        TextEditingController(text: plan?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: plan?.description ?? '');
    _promotionController =
        TextEditingController(text: plan?.promotionText ?? '');

    // Pre-fill dropdowns for edit mode
    _selectedType = plan?.planType;
    _selectedBillingCycle = plan?.billingCycle;
    _selectedStatus = plan != null ? (plan.isActive ? 'active' : 'inactive') : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _promotionController.dispose();
    super.dispose();
  }

  void _submit(List<String> types, List<AdminBranchOptionEntity> branches) {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final branchIds =
    _selectedBranchId != null ? [_selectedBranchId!] : <int>[];

    if (_isEditMode) {
      context.read<PlanFormBloc>().add(
        SubmitUpdatePlanEvent(
          planId: widget.existingPlan!.planId,
          request: UpdatePlanRequestModel(
            name: _nameController.text.trim(),
            planType: _selectedType,
            price: price,
            billingCycle: _selectedBillingCycle,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            promotionText: _promotionController.text.trim().isEmpty
                ? null
                : _promotionController.text.trim(),
            status: _selectedStatus,
            branchIds: branchIds.isEmpty ? null : branchIds,
          ),
        ),
      );
    } else {
      context.read<PlanFormBloc>().add(
        SubmitCreatePlanEvent(
          request: CreatePlanRequestModel(
            name: _nameController.text.trim(),
            planType: _selectedType!,
            price: price,
            billingCycle: _selectedBillingCycle!,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            promotionText: _promotionController.text.trim().isEmpty
                ? null
                : _promotionController.text.trim(),
            status: _selectedStatus!,
            branchIds: branchIds,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanFormBloc, PlanFormState>(
      listener: (context, state) {
        if (state is PlanFormSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
          widget.onSuccess();
        }
      },
      builder: (context, state) {
        if (state is PlanFormDataLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final types = state is PlanFormDataLoaded
            ? state.types
            : state is PlanFormSubmitting
            ? state.types
            : state is PlanFormError
            ? state.types
            : <String>[];

        final branches = state is PlanFormDataLoaded
            ? state.branches
            : state is PlanFormSubmitting
            ? state.branches
            : state is PlanFormError
            ? state.branches
            : <AdminBranchOptionEntity>[];

        final isSubmitting = state is PlanFormSubmitting;

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header ───────────────────────────────────────────────
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isEditMode ? 'Edit Plan' : 'Add New Plan',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Plan Name ────────────────────────────────────────────
                  _FormLabel('Plan Name *'),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('e.g. Gold Monthly'),
                    validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // ── Type / Activity ──────────────────────────────────────
                  _FormLabel('Type / Activity *'),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: _inputDecoration('Select type'),
                    items: types
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedType = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // ── Price ────────────────────────────────────────────────
                  _FormLabel('Price *'),
                  TextFormField(
                    controller: _priceController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: _inputDecoration('e.g. 49.99'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (double.tryParse(v.trim()) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Duration ─────────────────────────────────────────────
                  _FormLabel('Duration *'),
                  DropdownButtonFormField<String>(
                    value: _selectedBillingCycle,
                    decoration: _inputDecoration('Select duration'),
                    items: _billingCycles
                        .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(_formatBillingCycle(c)),
                    ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedBillingCycle = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // ── Description (optional) ───────────────────────────────
                  _FormLabel('Description'),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: _inputDecoration('Optional description'),
                  ),
                  const SizedBox(height: 14),

                  // ── Promotion (optional) ─────────────────────────────────
                  _FormLabel('Promotion'),
                  TextFormField(
                    controller: _promotionController,
                    decoration: _inputDecoration('e.g. 10% off for new members'),
                  ),
                  const SizedBox(height: 14),

                  // ── Status ───────────────────────────────────────────────
                  _FormLabel('Status *'),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: _inputDecoration('Select status'),
                    items: _statuses
                        .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(
                        s[0].toUpperCase() + s.substring(1),
                      ),
                    ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedStatus = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // ── Available Branches ───────────────────────────────────
                  _FormLabel('Available Branches *'),
                  DropdownButtonFormField<int>(
                    value: _selectedBranchId,
                    decoration: _inputDecoration('Select branch'),
                    items: branches
                        .map((b) => DropdownMenuItem(
                      value: b.branchId,
                      child: Text(b.branchName),
                    ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedBranchId = v),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Note: Multi-select support coming soon',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ),

                  // ── Error message ────────────────────────────────────────
                  if (state is PlanFormError) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Color(0xFFD32F2F)),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── Save button ──────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                      isSubmitting ? null : () => _submit(types, branches),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        _isEditMode ? 'Save Changes' : 'Create Plan',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatBillingCycle(String cycle) {
    return switch (cycle) {
      'monthly' => '1 Month',
      'quarterly' => '3 Months',
      'yearly' => '1 Year',
      'one_time' => 'One Time',
      _ => cycle,
    };
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
        const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD32F2F)),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF424242),
        ),
      ),
    );
  }
}