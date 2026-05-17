// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_services_screen.dart
//
// CHANGES vs previous version:
//   - _ServiceFormDialog now includes `isActive` toggle (SwitchListTile).
//     - Edit form: shows the current isActive value; allows toggling.
//     - Create form: not shown (defaults to true in body).
//     This maps to pt_services.is_active (boolean column in DB).
//   - _submit() includes `isActive` in the body for both create and edit.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../domain/entities/pt_service_entity.dart';
import '../bloc/services/pt_service_bloc.dart';

class TrainerServicesScreen extends StatefulWidget {
  final int  tenantId;
  /// 0 = admin/owner (all-trainers mode)
  final int  trainerId;
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;

  const TrainerServicesScreen({
    super.key,
    required this.tenantId,
    required this.trainerId,
    required this.isAdmin,
    required this.trainers,
  });

  @override
  State<TrainerServicesScreen> createState() =>
      _TrainerServicesScreenState();
}

class _TrainerServicesScreenState extends State<TrainerServicesScreen> {
  late final PtServiceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<PtServiceBloc>();
    _load();
  }

  void _load() {
    _bloc.add(PtServicesLoadRequested(
      trainerId: widget.isAdmin ? null : widget.trainerId,
      tenantId:  widget.tenantId,
    ));
  }

  String _trainerName(int trainerId) {
    try {
      return widget.trainers
          .firstWhere((t) => t.trainerId == trainerId)
          .fullName;
    } catch (_) {
      return 'Trainer #$trainerId';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return BlocConsumer<PtServiceBloc, PtServiceState>(
      listener: (ctx, state) {
        if (state is PtServiceMutationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is PtServiceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: tokens.colors.error,
            ),
          );
        }
      },
      builder: (ctx, state) {
        return Scaffold(
          backgroundColor: tokens.colors.background,
          appBar: AppBar(
            title: Text(
              widget.isAdmin ? 'All PT Services' : 'My Services',
              style: TextStyle(color: tokens.colors.label),
            ),
            backgroundColor: tokens.colors.surface,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: tokens.colors.primary),
                onPressed: () => _showCreateDialog(context),
              ),
            ],
          ),
          body: _buildBody(state, tokens),
        );
      },
    );
  }

  Widget _buildBody(PtServiceState state, dynamic tokens) {
    if (state is PtServiceLoading || state is PtServiceMutating) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PtServiceError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }

    final services =
        state is PtServiceLoaded ? state.services : <PtServiceEntity>[];

    if (services.isEmpty) {
      return const Center(child: Text('No PT services found.'));
    }

    return RefreshIndicator(
      onRefresh: () async => _load(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _ServiceCard(
          service:     services[i],
          trainerName: _trainerName(services[i].trainerId),
          showBadge:   widget.isAdmin,
          onEdit:      (svc) => _showEditDialog(context, svc),
          onDelete:    (svc) => _confirmDelete(context, svc),
        ),
      ),
    );
  }

  // ── Dialogs ────────────────────────────────────────────────────────────────

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _ServiceFormDialog(
        isAdmin:          widget.isAdmin,
        trainers:         widget.trainers,
        defaultTrainerId: widget.trainerId,
        onSubmit: (trainerId, body) {
          _bloc.add(PtServiceCreateRequested(
            trainerId: trainerId,
            tenantId:  widget.tenantId,
            body:      body,
          ));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, PtServiceEntity svc) {
    showDialog(
      context: context,
      builder: (_) => _ServiceFormDialog(
        isAdmin:          widget.isAdmin,
        trainers:         widget.trainers,
        defaultTrainerId: svc.trainerId,
        initialService:   svc,
        onSubmit: (_, body) {
          _bloc.add(PtServiceUpdateRequested(
            serviceId: svc.serviceId,
            body:      body,
          ));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, PtServiceEntity svc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text('Delete "${svc.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _bloc.add(PtServiceDeleteRequested(svc.serviceId));
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ── Service card ───────────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  final PtServiceEntity service;
  final String trainerName;
  final bool showBadge;
  final void Function(PtServiceEntity) onEdit;
  final void Function(PtServiceEntity) onDelete;

  const _ServiceCard({
    required this.service,
    required this.trainerName,
    required this.showBadge,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Card(
      color: tokens.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.card.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    style: TextStyle(
                      color: tokens.colors.label,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (!service.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tokens.colors.muted.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Inactive',
                        style: TextStyle(
                            color: tokens.colors.muted, fontSize: 11)),
                  ),
              ],
            ),
            if (showBadge) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tokens.colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'By $trainerName',
                  style: TextStyle(
                    color: tokens.colors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (service.description != null &&
                service.description!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(service.description!,
                  style: TextStyle(
                      color: tokens.colors.body, fontSize: 13)),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer, size: 14, color: tokens.colors.muted),
                const SizedBox(width: 4),
                Text('${service.durationMinutes} min',
                    style: TextStyle(
                        color: tokens.colors.body, fontSize: 13)),
                const SizedBox(width: 16),
                Icon(Icons.attach_money,
                    size: 14, color: tokens.colors.muted),
                Text('\$${service.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: tokens.colors.body, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => onEdit(service),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: () => onDelete(service),
                  icon: Icon(Icons.delete_outline,
                      size: 16, color: tokens.colors.danger),
                  label: Text('Delete',
                      style: TextStyle(color: tokens.colors.danger)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Service form dialog ────────────────────────────────────────────────────────
//
// EDIT vs CREATE:
//   Create: isActive defaults to true; switch NOT shown (unnecessary clutter).
//   Edit:   isActive switch shown so admin can re-activate a deactivated service.

class _ServiceFormDialog extends StatefulWidget {
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;
  final int defaultTrainerId;
  final PtServiceEntity? initialService;
  final void Function(int trainerId, Map<String, dynamic> body) onSubmit;

  const _ServiceFormDialog({
    required this.isAdmin,
    required this.trainers,
    required this.defaultTrainerId,
    this.initialService,
    required this.onSubmit,
  });

  @override
  State<_ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends State<_ServiceFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _duration;
  late final TextEditingController _price;
  int?  _selectedTrainerId;
  bool  _isActive = true;       // ← NEW: maps to pt_services.is_active

  @override
  void initState() {
    super.initState();
    final s      = widget.initialService;
    _name        = TextEditingController(text: s?.name ?? '');
    _description = TextEditingController(text: s?.description ?? '');
    _duration    = TextEditingController(
        text: s != null ? '${s.durationMinutes}' : '60');
    _price       = TextEditingController(
        text: s != null ? '${s.price}' : '');
    final trainerStillActive =
        widget.trainers.any((t) => t.trainerId == widget.defaultTrainerId);
    _selectedTrainerId =
        (widget.defaultTrainerId != 0 && trainerStillActive)
            ? widget.defaultTrainerId
            : null;
    _isActive = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _duration.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialService != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Service' : 'New PT Service'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Trainer picker (admin only) ──────────────────────────────
              if (widget.isAdmin && widget.trainers.isNotEmpty) ...[
                DropdownButtonFormField<int>(
                  value: _selectedTrainerId,
                  hint: const Text('Assign to Trainer'),
                  items: widget.trainers.map((t) {
                    return DropdownMenuItem(
                      value: t.trainerId,
                      child: Text(t.fullName),
                    );
                  }).toList(),
                  onChanged: (v) =>
                      setState(() => _selectedTrainerId = v),
                  validator: (v) =>
                  v == null ? 'Please select a trainer' : null,
                ),
                const SizedBox(height: 10),
              ],

              // ── Name ────────────────────────────────────────────────────
              _field(_name, 'Service Name',
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null),

              // ── Description ─────────────────────────────────────────────
              _field(_description, 'Description (optional)'),

              // ── Duration ─────────────────────────────────────────────────
              _field(_duration, 'Duration (minutes)',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                  int.tryParse(v ?? '') == null ? 'Enter a number' : null),

              // ── Price ────────────────────────────────────────────────────
              _field(_price, 'Price',
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) =>
                  double.tryParse(v ?? '') == null
                      ? 'Enter a price'
                      : null),

              // ── isActive toggle (edit mode only) ─────────────────────────
              // Maps to pt_services.is_active (boolean) in the DB.
              if (isEdit) ...[
                const SizedBox(height: 4),
                SwitchListTile(
                  title: const Text('Active'),
                  subtitle:
                      const Text('Inactive services are hidden from members'),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _field(
      TextEditingController ctrl,
      String label, {
        TextInputType? keyboardType,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller:   ctrl,
        keyboardType: keyboardType,
        decoration:   InputDecoration(labelText: label),
        validator:    validator,
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final trainerId = _selectedTrainerId ?? widget.defaultTrainerId;
    if (trainerId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a trainer.')),
      );
      return;
    }

    final isEdit = widget.initialService != null;

    final body = <String, dynamic>{
      'name':            _name.text.trim(),
      'description':     _description.text.trim(),
      'durationMinutes': int.parse(_duration.text.trim()),
      'price':           double.parse(_price.text.trim()),
      // isActive only sent for edit — create always defaults to true
      if (isEdit) 'isActive': _isActive,
    };

    widget.onSubmit(trainerId, body);
  }
}
