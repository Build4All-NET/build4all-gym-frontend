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

import '../../../../../common/widgets/app_toast.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../domain/entities/pt_service_entity.dart';
import '../bloc/services/pt_service_bloc.dart';
import '../widgets/pt_form_dialog_kit.dart';

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

  String _trainerName(int trainerId, BuildContext context) {
    try {
      return widget.trainers
          .firstWhere((t) => t.trainerId == trainerId)
          .fullName;
    } catch (_) {
      return AppLocalizations.of(context)!.trainer_trainerNumber(trainerId);
    }
  }

  /// Only Admin/Owner/Manager can create/edit/delete services — the backend
  /// rejects writes from anyone else (e.g. Reception, who can still view this
  /// screen in admin-mode). Checks the real JWT role, not the loose
  /// "admin-mode view" flag (widget.isAdmin), which also covers Reception.
  bool _canManage(BuildContext context) =>
      context.read<AdminProfileCubit>().state.isAdminRole;

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final canManage = _canManage(context);

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
              widget.isAdmin ? AppLocalizations.of(context)!.trainer_servicesAllTitle : AppLocalizations.of(context)!.trainer_servicesMyTitle,
              style: TextStyle(color: tokens.colors.label),
            ),
            backgroundColor: tokens.colors.surface,
            elevation: 0,
            actions: [
              if (canManage)
                IconButton(
                  icon: Icon(Icons.add, color: tokens.colors.primary),
                  onPressed: () => _showCreateDialog(context),
                ),
            ],
          ),
          body: _buildBody(context, state, tokens, canManage),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PtServiceState state, dynamic tokens, bool canManage) {
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
            ElevatedButton(onPressed: _load, child: Text(AppLocalizations.of(context)!.retry)),
          ],
        ),
      );
    }

    final services =
        state is PtServiceLoaded ? state.services : <PtServiceEntity>[];

    if (services.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.trainer_noPtServicesFound));
    }

    return RefreshIndicator(
      onRefresh: () async => _load(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _ServiceCard(
          service:     services[i],
          trainerName: _trainerName(services[i].trainerId, context),
          showBadge:   widget.isAdmin,
          onEdit:      canManage ? (svc) => _showEditDialog(context, svc) : null,
          onDelete:    canManage ? (svc) => _confirmDelete(context, svc) : null,
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
        title: Text(AppLocalizations.of(context)!.trainer_deleteServiceTitle),
        content: Text(AppLocalizations.of(context)!.trainer_deleteServiceMessage(svc.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.general_cancel),
          ),
          TextButton(
            onPressed: () {
              _bloc.add(PtServiceDeleteRequested(svc.serviceId));
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.admin_members_actionDelete,
                style: const TextStyle(color: Colors.red)),
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
  final void Function(PtServiceEntity)? onEdit;
  final void Function(PtServiceEntity)? onDelete;

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
                    child: Text(AppLocalizations.of(context)!.trainer_inactiveBadge,
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
                  AppLocalizations.of(context)!.trainer_byName(trainerName),
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
                Text(
                    AppLocalizations.of(context)!
                        .memberHomeDurationMinutes(service.durationMinutes),
                    style: TextStyle(
                        color: tokens.colors.body, fontSize: 13)),
                const SizedBox(width: 16),
                Icon(Icons.attach_money,
                    size: 14, color: tokens.colors.muted),
                Text('\$${service.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: tokens.colors.body, fontSize: 13)),
                const SizedBox(width: 16),
                Icon(Icons.percent_rounded,
                    size: 14, color: tokens.colors.muted),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!
                      .trainer_commissionValue(service.commissionPercentage.toStringAsFixed(1)),
                  style: TextStyle(
                      color: tokens.colors.body, fontSize: 13),
                ),
              ],
            ),
            if (onEdit != null || onDelete != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    TextButton.icon(
                      onPressed: () => onEdit!(service),
                      icon: const Icon(Icons.edit, size: 16),
                      label: Text(AppLocalizations.of(context)!.admin_members_actionEdit),
                    ),
                  if (onEdit != null && onDelete != null) const SizedBox(width: 4),
                  if (onDelete != null)
                    TextButton.icon(
                      onPressed: () => onDelete!(service),
                      icon: Icon(Icons.delete_outline,
                          size: 16, color: tokens.colors.danger),
                      label: Text(AppLocalizations.of(context)!.admin_members_actionDelete,
                          style: TextStyle(color: tokens.colors.danger)),
                    ),
                ],
              ),
            ],
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
  late final TextEditingController _commissionPercentage;
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
    _commissionPercentage = TextEditingController(
        text: s != null ? '${s.commissionPercentage}' : '0');
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
    _commissionPercentage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialService != null;
    final l10n   = AppLocalizations.of(context)!;
    final c      = context.read<ThemeCubit>().state.tokens.colors;

    return PtFormDialogScaffold(
      header: PtDialogHeader(
        icon:     Icons.design_services_rounded,
        title:    isEdit ? l10n.trainer_editService : l10n.trainer_newPtService,
        subtitle: isEdit ? l10n.trainer_editServiceSubtitle : l10n.trainer_newServiceSubtitle,
        onClose:  () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Trainer picker (admin only) ──────────────────────────────
            if (widget.isAdmin && widget.trainers.isNotEmpty) ...[
              DropdownButtonFormField<int>(
                value: _selectedTrainerId,
                decoration: ptFieldDecoration(c,
                    label: l10n.trainer_assignToTrainer,
                    icon: Icons.person_outline_rounded),
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.muted),
                items: widget.trainers.map((t) {
                  return DropdownMenuItem(
                    value: t.trainerId,
                    child: Text(t.fullName),
                  );
                }).toList(),
                onChanged: (v) =>
                    setState(() => _selectedTrainerId = v),
                validator: (v) =>
                v == null ? l10n.trainer_selectTrainerRequired : null,
              ),
              const SizedBox(height: 14),
            ],

            // ── Basic info ──────────────────────────────────────────────
            PtSectionLabel(icon: Icons.info_outline_rounded, text: l10n.trainer_sectionBasicInfo),
            _field(c, _name, l10n.trainer_serviceNameLabel,
                icon: Icons.badge_outlined,
                validator: (v) =>
                v == null || v.isEmpty ? l10n.trainer_requiredField : null),
            const SizedBox(height: 12),
            _field(c, _description, l10n.trainer_descriptionOptional,
                icon: Icons.notes_rounded,
                maxLines: 2),
            const SizedBox(height: 12),

            // ── Pricing ──────────────────────────────────────────────────
            PtSectionLabel(icon: Icons.payments_outlined, text: l10n.trainer_sectionPricing),
            _fieldRow(
              _field(c, _duration, l10n.trainer_durationMinutes,
                  icon: Icons.timer_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                  int.tryParse(v ?? '') == null ? l10n.trainer_enterNumber : null),
              _field(c, _price, l10n.trainer_priceLabel,
                  icon: Icons.attach_money_rounded,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) =>
                  double.tryParse(v ?? '') == null
                      ? l10n.trainer_enterPrice
                      : null),
            ),
            _field(c, _commissionPercentage, l10n.trainer_commissionPercentageLabel,
                icon: Icons.percent_rounded,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null) return l10n.trainer_enterNumber;
                  if (n < 0 || n > 100) return l10n.trainer_commissionRangeError;
                  return null;
                }),
            const SizedBox(height: 12),

            // ── isActive toggle (edit mode only) ─────────────────────────
            // Maps to pt_services.is_active (boolean) in the DB.
            if (isEdit)
              PtSwitchCard(
                icon: Icons.visibility_outlined,
                title: l10n.trainer_activeLabel,
                subtitle: l10n.trainer_inactiveHidden,
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
          ],
        ),
      ),
      footer: PtDialogFooter(
        cancelLabel: l10n.general_cancel,
        submitLabel: isEdit ? l10n.editProfileSave : l10n.trainer_addPtService,
        submitIcon:  isEdit ? Icons.check_rounded : Icons.add_rounded,
        onCancel:    () => Navigator.pop(context),
        onSubmit:    _submit,
      ),
    );
  }

  Widget _fieldRow(Widget left, Widget right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      ),
    );
  }

  Widget _field(
      ColorTokens c,
      TextEditingController ctrl,
      String label, {
        required IconData icon,
        TextInputType? keyboardType,
        int maxLines = 1,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller:   ctrl,
      keyboardType: keyboardType,
      maxLines:     maxLines,
      style:        TextStyle(fontSize: 14, color: c.label),
      decoration:   ptFieldDecoration(c, label: label, icon: icon),
      validator:    validator,
    );
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final trainerId = _selectedTrainerId ?? widget.defaultTrainerId;
    if (trainerId == 0) {
      AppToast.error(context, l10n.trainer_selectTrainerSnackbar);
      return;
    }

    final isEdit = widget.initialService != null;

    final body = <String, dynamic>{
      'name':            _name.text.trim(),
      'description':     _description.text.trim(),
      'durationMinutes': int.parse(_duration.text.trim()),
      'price':           double.parse(_price.text.trim()),
      'commissionPercentage': double.parse(_commissionPercentage.text.trim()),
      // isActive only sent for edit — create always defaults to true
      if (isEdit) 'isActive': _isActive,
    };

    widget.onSubmit(trainerId, body);
  }
}
