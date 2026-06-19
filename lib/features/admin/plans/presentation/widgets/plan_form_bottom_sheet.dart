import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../domain/entities/admin_plan_list_item_entity.dart';
import '../../domain/usecases/admin_plans_usecases.dart';
import '../../data/services/admin_plans_remote_service.dart';
import '../../data/repositories/admin_plans_repository_impl.dart';
import '../../data/models/CreatePlanRequestModel.dart';
import '../../data/models/UpdatePlanRequestModel.dart';
import '../../data/models/plan_feature_model.dart';
import '../../data/models/plan_promotion_model.dart';
import '../bloc/plan_form/plan_form_bloc.dart';
import '../../../../../common/widgets/form_section_kit.dart';

class PlanFormBottomSheet {
  static void show(
    BuildContext context, {
    AdminPlanListItemEntity? existingPlan,
    required VoidCallback onSuccess,
  }) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider(
        create: (_) {
          final repo = AdminPlansRepositoryImpl(
            remoteDatasource: AdminPlansRemoteDatasourceImpl(),
          );
          return PlanFormBloc(
            getPlanTypes: GetPlanTypesUseCase(repository: repo),
            getBranches:  GetBranchesUseCase(repository: repo),
            createPlanType: CreatePlanTypeUseCase(repository: repo),
            createPlan:   CreatePlanUseCase(repository: repo),
            updatePlan:   UpdatePlanUseCase(repository: repo),
          )..add(LoadFormDataEvent());
        },
        child: _PlanFormContent(
          existingPlan: existingPlan,
          onSuccess: onSuccess,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _FeatureRow {
  final TextEditingController name;
  final TextEditingController value;
  _FeatureRow()
      : name = TextEditingController(),
        value = TextEditingController();
  _FeatureRow.prefilled(String n, String? v)
      : name = TextEditingController(text: n),
        value = TextEditingController(text: v ?? '');
  void dispose() {
    name.dispose();
    value.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PlanFormContent extends StatefulWidget {
  final AdminPlanListItemEntity? existingPlan;
  final VoidCallback onSuccess;

  const _PlanFormContent({this.existingPlan, required this.onSuccess});

  @override
  State<_PlanFormContent> createState() => _PlanFormContentState();
}

class _PlanFormContentState extends State<_PlanFormContent> {
  final _formKey = GlobalKey<FormState>();

  // Basic info
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;

  // Membership settings
  late final TextEditingController _allowedVisitsController;
  late final TextEditingController _freezeDaysController;
  late final TextEditingController _maxFreezesController;
  late final TextEditingController _gracePeriodController;

  String? _selectedType;
  bool _isCustomType = false;
  late final TextEditingController _customTypeController;
  String? _selectedBillingCycle;
  late final TextEditingController _customDurationController;
  String? _selectedStatus;
  bool _unlimitedVisits = true;
  bool _autoRenew = false;
  bool _isFeatured = false;

  // Access time restriction
  bool _restrictAccessHours = false;
  TimeOfDay _accessStart = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _accessEnd   = const TimeOfDay(hour: 12, minute: 0);

  // Features
  final List<_FeatureRow> _featureRows = [];

  // Promotion
  bool _hasPromotion = false;
  late final TextEditingController _promoTitleController;
  late final TextEditingController _promoDescController;
  late final TextEditingController _promoDiscountValueController;
  String _promoDiscountType = 'fixed';
  DateTime? _promoStartDate;
  DateTime? _promoEndDate;

  bool get _isEditMode => widget.existingPlan != null;

  static const _billingCycles = [
    'monthly', 'quarterly', 'yearly', 'one_time', 'custom'
  ];
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
    _allowedVisitsController = TextEditingController(
        text: plan?.allowedVisits?.toString() ?? '');
    _freezeDaysController = TextEditingController(
        text: plan?.freezeDaysAllowance?.toString() ?? '');
    _maxFreezesController = TextEditingController(
        text: plan?.maxFreezesCount?.toString() ?? '');
    _gracePeriodController = TextEditingController(
        text: plan?.gracePeriodDays?.toString() ?? '');

    _selectedType = plan?.planType;
    _customTypeController = TextEditingController();
    _selectedBillingCycle = _normaliseCycle(plan?.billingCycle);
    _customDurationController = TextEditingController(
      text: plan?.durationDays?.toString() ?? '',
    );
    _selectedStatus =
        plan != null ? (plan.isActive ? 'active' : 'inactive') : null;
    _unlimitedVisits = plan?.allowedVisits == null;
    _autoRenew = plan?.autoRenew ?? false;
    _isFeatured = plan?.isFeatured ?? false;

    if (plan?.gymAccessStart != null && plan?.gymAccessEnd != null) {
      _restrictAccessHours = true;
      _accessStart = _parseTime(plan!.gymAccessStart!);
      _accessEnd   = _parseTime(plan.gymAccessEnd!);
    }

    // Pre-populate features
    if (plan != null) {
      for (final f in plan.features) {
        _featureRows.add(_FeatureRow.prefilled(f.featureName, f.featureValue));
      }
    }

    // Pre-populate promotion
    final promo = plan?.promotion;
    _hasPromotion = promo != null;
    _promoTitleController =
        TextEditingController(text: promo?.title ?? '');
    _promoDescController =
        TextEditingController(text: promo?.description ?? '');
    _promoDiscountValueController = TextEditingController(
        text: promo?.discountValue.toString() ?? '0');
    _promoDiscountType = promo?.discountType ?? 'fixed';
    _promoStartDate = promo?.startDate;
    _promoEndDate = promo?.endDate;
  }

  String? _normaliseCycle(String? raw) {
    if (raw == null) return null;
    final v = raw.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
    if (v.contains('one') || v.contains('1_time')) return 'one_time';
    if (v.contains('month') || v == '1_month') return 'monthly';
    if (v.contains('quarter') || v == '3_months') return 'quarterly';
    if (v.contains('year') || v == '1_year') return 'yearly';
    if (v.contains('custom')) return 'custom';
    if (_billingCycles.contains(v)) return v;
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customTypeController.dispose();
    _customDurationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _allowedVisitsController.dispose();
    _freezeDaysController.dispose();
    _maxFreezesController.dispose();
    _gracePeriodController.dispose();
    _promoTitleController.dispose();
    _promoDescController.dispose();
    _promoDiscountValueController.dispose();
    for (final row in _featureRows) {
      row.dispose();
    }
    super.dispose();
  }

  // ── Date picker helper ─────────────────────────────────────────────────────

  Future<void> _pickDate(
      {required bool isStart, required ColorTokens c}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _promoStartDate : _promoEndDate) ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _promoStartDate = picked;
        } else {
          _promoEndDate = picked;
        }
      });
    }
  }

  // ── Time helpers ───────────────────────────────────────────────────────────

  TimeOfDay _parseTime(String hhmm) {
    final parts = hhmm.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickAccessTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _accessStart : _accessEnd,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _accessStart = picked;
        } else {
          _accessEnd = picked;
        }
      });
    }
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  void _submit(List<String> types) {
    if (!_formKey.currentState!.validate()) return;

    final effectiveType = _isCustomType
        ? _customTypeController.text.trim()
        : _selectedType;

    final isCustomCycle = _selectedBillingCycle == 'custom';
    final customDurationDays = isCustomCycle
        ? int.tryParse(_customDurationController.text.trim())
        : null;

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final allowedVisits = _unlimitedVisits
        ? null
        : int.tryParse(_allowedVisitsController.text.trim());
    final freezeDays = int.tryParse(_freezeDaysController.text.trim());
    final maxFreezes = int.tryParse(_maxFreezesController.text.trim());
    final gracePeriod = int.tryParse(_gracePeriodController.text.trim());
    final gymAccessStart = _restrictAccessHours ? _formatTime(_accessStart) : null;
    final gymAccessEnd   = _restrictAccessHours ? _formatTime(_accessEnd)   : null;

    // Build features list
    final featureModels = _featureRows
        .where((r) => r.name.text.trim().isNotEmpty)
        .map((r) => PlanFeatureModel(
              featureName: r.name.text.trim(),
              featureValue: r.value.text.trim().isEmpty
                  ? null
                  : r.value.text.trim(),
            ))
        .toList();

    // Build promotion
    PlanPromotionModel? promoModel;
    if (_hasPromotion && _promoTitleController.text.trim().isNotEmpty) {
      promoModel = PlanPromotionModel(
        title: _promoTitleController.text.trim(),
        description: _promoDescController.text.trim().isEmpty
            ? null
            : _promoDescController.text.trim(),
        discountType: _promoDiscountType,
        discountValue:
            double.tryParse(_promoDiscountValueController.text.trim()) ?? 0.0,
        startDate: _promoStartDate != null
            ? DateFormat('yyyy-MM-dd').format(_promoStartDate!)
            : null,
        endDate: _promoEndDate != null
            ? DateFormat('yyyy-MM-dd').format(_promoEndDate!)
            : null,
      );
    } else if (!_hasPromotion && _isEditMode) {
      // User turned OFF existing promotion — send empty title to deactivate
      promoModel = const PlanPromotionModel(title: '');
    }

    if (_isEditMode) {
      context.read<PlanFormBloc>().add(
            SubmitUpdatePlanEvent(
              planId: widget.existingPlan!.planId,
              request: UpdatePlanRequestModel(
                name: _nameController.text.trim(),
                planType: effectiveType,
                price: price,
                billingCycle: _selectedBillingCycle,
                customDurationDays: customDurationDays,
                description: _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
                status: _selectedStatus,
                branchIds: null,
                allowedVisits: allowedVisits,
                freezeDaysAllowance: freezeDays,
                maxFreezesCount: maxFreezes,
                autoRenew: _autoRenew,
                isFeatured: _isFeatured,
                gracePeriodDays: gracePeriod,
                gymAccessStart: gymAccessStart ?? '',
                gymAccessEnd: gymAccessEnd ?? '',
                promotion: promoModel,
                features: featureModels,
              ),
            ),
          );
    } else {
      context.read<PlanFormBloc>().add(
            SubmitCreatePlanEvent(
              isCustomType: _isCustomType,
              request: CreatePlanRequestModel(
                name: _nameController.text.trim(),
                planType: effectiveType!,
                price: price,
                billingCycle: _selectedBillingCycle!,
                customDurationDays: customDurationDays,
                description: _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
                status: _selectedStatus!,
                branchIds: const <int>[],
                allowedVisits: allowedVisits,
                freezeDaysAllowance: freezeDays,
                maxFreezesCount: maxFreezes,
                autoRenew: _autoRenew,
                isFeatured: _isFeatured,
                gracePeriodDays: gracePeriod,
                gymAccessStart: gymAccessStart,
                gymAccessEnd: gymAccessEnd,
                promotion: promoModel,
                features: featureModels,
              ),
            ),
          );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;

    return BlocConsumer<PlanFormBloc, PlanFormState>(
      listener: (context, state) {
        if (state is PlanFormSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: c.success,
          ));
          widget.onSuccess();
        }
      },
      builder: (context, state) {
        if (state is PlanFormDataLoading) {
          return SizedBox(
            height: 200,
            child: Center(
                child: CircularProgressIndicator(color: c.primary)),
          );
        }

        final types = state is PlanFormDataLoaded
            ? state.types
            : state is PlanFormSubmitting
                ? state.types
                : state is PlanFormError
                    ? state.types
                    : <String>[];

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
                  // ── Handle ──────────────────────────────────────────────
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: c.border.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isEditMode ? 'Edit Plan' : 'Add New Plan',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: c.label),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: c.background,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close_rounded,
                              size: 20, color: c.muted),
                        ),
                      ),
                    ],
                  ),

                  // ════════════════════════════════════════════════════════
                  // SECTION 1: Basic Info
                  // ════════════════════════════════════════════════════════
                  _sectionHeader('Basic Info', Icons.info_outline_rounded, c),

                  _FormLabel('Plan Name *', c),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: c.label),
                    decoration: _inputDec('e.g. Gold Monthly', c),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  _FormLabel('Type / Activity *', c),
                  if (_isCustomType) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _customTypeController,
                            style: TextStyle(color: c.label),
                            textCapitalization: TextCapitalization.words,
                            decoration: _inputDec('Enter type (e.g. Yoga)', c),
                            validator: (v) => _isCustomType &&
                                    (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => setState(() {
                            _isCustomType = false;
                            _customTypeController.clear();
                            _selectedType = null;
                          }),
                          child: Container(
                            padding: const EdgeInsets.all(11),
                            decoration: BoxDecoration(
                              color: c.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: c.border.withOpacity(0.3)),
                            ),
                            child: Icon(Icons.close_rounded,
                                size: 18, color: c.muted),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: _inputDec('Select type', c),
                      items: [
                        // Keep current value in the list while types are still
                        // loading, so Flutter's assertion (value must be in items)
                        // never fires during the edit-plan flow.
                        if (_selectedType != null &&
                            !types.contains(_selectedType))
                          DropdownMenuItem(
                              value: _selectedType!,
                              child: Text(_selectedType!)),
                        ...types.map((t) =>
                            DropdownMenuItem(value: t, child: Text(t))),
                        DropdownMenuItem(
                          value: '__new__',
                          child: Row(
                            children: [
                              Icon(Icons.add_rounded,
                                  size: 16, color: c.primary),
                              const SizedBox(width: 6),
                              Text('Add new type…',
                                  style: TextStyle(
                                      color: c.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (v) {
                        if (v == '__new__') {
                          setState(() {
                            _isCustomType = true;
                            _selectedType = null;
                          });
                        } else {
                          setState(() => _selectedType = v);
                        }
                      },
                      validator: (v) =>
                          !_isCustomType && v == null ? 'Required' : null,
                    ),
                  ],
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FormLabel('Price *', c),
                            TextFormField(
                              controller: _priceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: TextStyle(color: c.label),
                              decoration: _inputDec('49.99', c),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Required';
                                if (double.tryParse(v.trim()) == null)
                                  return 'Invalid';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FormLabel('Duration *', c),
                            DropdownButtonFormField<String>(
                              value: _selectedBillingCycle,
                              decoration: _inputDec('Duration', c),
                              items: _billingCycles
                                  .map((cyc) => DropdownMenuItem(
                                        value: cyc,
                                        child: Text(_formatCycle(cyc)),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(
                                  () => _selectedBillingCycle = v),
                              validator: (v) =>
                                  v == null ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_selectedBillingCycle == 'custom') ...[
                    const SizedBox(height: 10),
                    _FormLabel('Custom Duration (days) *', c),
                    TextFormField(
                      controller: _customDurationController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: c.label),
                      decoration: _inputDec('e.g. 45', c),
                      validator: (v) {
                        if (_selectedBillingCycle == 'custom' &&
                            (v == null || v.trim().isEmpty))
                          return 'Enter number of days';
                        if (_selectedBillingCycle == 'custom' &&
                            int.tryParse(v!.trim()) == null)
                          return 'Must be a whole number';
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FormLabel('Status *', c),
                            DropdownButtonFormField<String>(
                              value: _selectedStatus,
                              decoration: _inputDec('Status', c),
                              items: _statuses
                                  .map((s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s[0].toUpperCase() +
                                            s.substring(1)),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedStatus = v),
                              validator: (v) =>
                                  v == null ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _FormLabel('Description', c),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 2,
                    style: TextStyle(color: c.label),
                    decoration: _inputDec('Optional plan description', c),
                  ),

                  // ════════════════════════════════════════════════════════
                  // SECTION 2: Membership Settings
                  // ════════════════════════════════════════════════════════
                  _sectionHeader('Membership Settings',
                      Icons.settings_outlined, c),

                  _FormLabel('Allowed Visits', c),
                  Row(
                    children: [
                      Expanded(
                          child: _toggleButton('Unlimited', _unlimitedVisits,
                              () => setState(() => _unlimitedVisits = true),
                              c)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _toggleButton(
                              'Limited',
                              !_unlimitedVisits,
                              () =>
                                  setState(() => _unlimitedVisits = false),
                              c)),
                    ],
                  ),
                  if (!_unlimitedVisits) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _allowedVisitsController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: c.label),
                      decoration: _inputDec('Number of visits', c),
                      validator: (v) {
                        if (!_unlimitedVisits &&
                            (v == null || v.trim().isEmpty))
                          return 'Enter visit count';
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 12),

                  _FormLabel('Grace Period (Days)', c),
                  TextFormField(
                    controller: _gracePeriodController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: c.label),
                    decoration:
                        _inputDec('Days after expiry before suspension', c),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: c.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: c.border.withOpacity(0.25)),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text('Auto Renew',
                              style: TextStyle(
                                  color: c.label,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          subtitle: Text('Renew automatically on expiry',
                              style: TextStyle(
                                  color: c.muted, fontSize: 12)),
                          value: _autoRenew,
                          activeColor: c.primary,
                          onChanged: (v) =>
                              setState(() => _autoRenew = v),
                        ),
                        Divider(
                            height: 1,
                            color: c.border.withOpacity(0.2)),
                        SwitchListTile(
                          title: Text('Featured Plan',
                              style: TextStyle(
                                  color: c.label,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          subtitle: Text(
                              'Highlight on member browse screen',
                              style: TextStyle(
                                  color: c.muted, fontSize: 12)),
                          value: _isFeatured,
                          activeColor: c.primary,
                          onChanged: (v) =>
                              setState(() => _isFeatured = v),
                        ),
                      ],
                    ),
                  ),

                  // ════════════════════════════════════════════════════════
                  // SECTION 3b: Access Hours Restriction
                  // ════════════════════════════════════════════════════════
                  _sectionHeader(
                      'Access Hours', Icons.access_time_rounded, c),

                  Container(
                    decoration: BoxDecoration(
                      color: c.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: c.border.withOpacity(0.25)),
                    ),
                    child: SwitchListTile(
                      title: Text('Restrict Entry Hours',
                          style: TextStyle(
                              color: c.label,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      subtitle: Text(
                          _restrictAccessHours
                              ? 'Members can only enter between the times below'
                              : 'Members can enter at any time',
                          style: TextStyle(color: c.muted, fontSize: 12)),
                      value: _restrictAccessHours,
                      activeColor: c.primary,
                      onChanged: (v) =>
                          setState(() => _restrictAccessHours = v),
                    ),
                  ),

                  if (_restrictAccessHours) ...[
                    const SizedBox(height: 12),
                    _FormLabel('Allowed Entry Window', c),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FormLabel('From', c),
                              GestureDetector(
                                onTap: () => _pickAccessTime(isStart: true),
                                child: _timeField(_accessStart, c),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FormLabel('Until', c),
                              GestureDetector(
                                onTap: () => _pickAccessTime(isStart: false),
                                child: _timeField(_accessEnd, c),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Members with booked sessions or PT can always enter during their session window.',
                      style: TextStyle(color: c.muted, fontSize: 11),
                    ),
                  ],

                  // ════════════════════════════════════════════════════════
                  // SECTION 4: Plan Features
                  // ════════════════════════════════════════════════════════
                  _sectionHeader(
                      'Plan Features', Icons.check_circle_outline_rounded, c),

                  if (_featureRows.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                          'Add features members will see on this plan (e.g. "Pool Access", "WiFi")',
                          style:
                              TextStyle(color: c.muted, fontSize: 12)),
                    ),

                  ..._featureRows.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final row = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              controller: row.name,
                              style: TextStyle(color: c.label),
                              decoration:
                                  _inputDec('Feature (e.g. WiFi)', c),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: row.value,
                              style: TextStyle(color: c.label),
                              decoration:
                                  _inputDec('Value (optional)', c),
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => setState(() {
                              _featureRows[idx].dispose();
                              _featureRows.removeAt(idx);
                            }),
                            child: Icon(Icons.close_rounded,
                                size: 20, color: c.danger),
                          ),
                        ],
                      ),
                    );
                  }),

                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _featureRows.add(_FeatureRow())),
                    icon: Icon(Icons.add_circle_outline_rounded,
                        size: 18, color: c.primary),
                    label: Text('Add Feature',
                        style: TextStyle(
                            color: c.primary, fontSize: 13)),
                  ),

                  // ════════════════════════════════════════════════════════
                  // SECTION 5: Promotion
                  // ════════════════════════════════════════════════════════
                  _sectionHeader(
                      'Promotion', Icons.local_offer_outlined, c),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Has Active Promotion',
                          style: TextStyle(
                              color: c.label,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      Switch(
                        value: _hasPromotion,
                        activeColor: c.primary,
                        onChanged: (v) =>
                            setState(() => _hasPromotion = v),
                      ),
                    ],
                  ),

                  if (_hasPromotion) ...[
                    const SizedBox(height: 8),
                    _FormLabel('Promotion Title *', c),
                    TextFormField(
                      controller: _promoTitleController,
                      style: TextStyle(color: c.label),
                      decoration:
                          _inputDec('e.g. Summer Special', c),
                      validator: (v) {
                        if (_hasPromotion &&
                            (v == null || v.trim().isEmpty))
                          return 'Title required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _FormLabel('Promotion Description', c),
                    TextFormField(
                      controller: _promoDescController,
                      maxLines: 2,
                      style: TextStyle(color: c.label),
                      decoration:
                          _inputDec('Optional details', c),
                    ),
                    const SizedBox(height: 12),

                    _FormLabel('Discount Type', c),
                    Row(
                      children: [
                        Expanded(
                          child: _toggleButton(
                              'Fixed Amount',
                              _promoDiscountType == 'fixed',
                              () => setState(
                                  () => _promoDiscountType = 'fixed'),
                              c),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _toggleButton(
                              'Percentage %',
                              _promoDiscountType == 'percentage',
                              () => setState(
                                  () => _promoDiscountType = 'percentage'),
                              c),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _FormLabel(
                        _promoDiscountType == 'percentage'
                            ? 'Discount %'
                            : 'Discount Amount',
                        c),
                    TextFormField(
                      controller: _promoDiscountValueController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                              decimal: true),
                      style: TextStyle(color: c.label),
                      decoration: _inputDec(
                          _promoDiscountType == 'percentage'
                              ? '0–100'
                              : '0.00',
                          c),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _FormLabel('Start Date', c),
                              GestureDetector(
                                onTap: () => _pickDate(
                                    isStart: true, c: c),
                                child: _dateField(
                                    _promoStartDate, 'No start date', c,
                                    isStart: true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _FormLabel('End Date', c),
                              GestureDetector(
                                onTap: () => _pickDate(
                                    isStart: false, c: c),
                                child: _dateField(
                                    _promoEndDate, 'No end date', c,
                                    isStart: false),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_promoStartDate != null || _promoEndDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'No end date = promotion stays active until manually deactivated',
                          style: TextStyle(
                              color: c.muted, fontSize: 11),
                        ),
                      ),
                  ],

                  // ── Error ─────────────────────────────────────────────────
                  if (state is PlanFormError) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: c.danger.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(state.message,
                          style: TextStyle(color: c.danger)),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── Save button ──────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () => _submit(types),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.success,
                        foregroundColor: c.onPrimary,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: c.onPrimary,
                                  strokeWidth: 2),
                            )
                          : Text(
                              _isEditMode
                                  ? 'Save Changes'
                                  : 'Create Plan',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
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

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon, ColorTokens c) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: c.primary),
          const SizedBox(width: 6),
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.primary)),
          const SizedBox(width: 8),
          Expanded(
              child: Divider(
                  color: c.border.withOpacity(0.3), height: 1)),
        ],
      ),
    );
  }

  Widget _toggleButton(
      String label, bool selected, VoidCallback onTap, ColorTokens c) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color:
              selected ? c.primary.withOpacity(0.12) : c.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                selected ? c.primary : c.border.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                color: selected ? c.primary : c.muted,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              )),
        ),
      ),
    );
  }

  Widget _timeField(TimeOfDay time, ColorTokens c) {
    final label =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.border.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, size: 15, color: c.muted),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: c.label,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _dateField(DateTime? date, String placeholder, ColorTokens c,
      {required bool isStart}) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.border.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined,
              size: 15, color: c.muted),
          const SizedBox(width: 6),
          Text(
            date != null
                ? DateFormat('dd MMM yyyy').format(date)
                : placeholder,
            style: TextStyle(
                color: date != null ? c.label : c.muted,
                fontSize: 13),
          ),
          if (date != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() {
                if (isStart) {
                  _promoStartDate = null;
                } else {
                  _promoEndDate = null;
                }
              }),
              child: Icon(Icons.close_rounded,
                  size: 14, color: c.muted),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCycle(String cycle) => switch (cycle) {
        'monthly' => '1 Month',
        'quarterly' => '3 Months',
        'yearly' => '1 Year',
        'one_time' => 'One Time',
        'custom' => 'Custom',
        _ => cycle,
      };

  InputDecoration _inputDec(String hint, ColorTokens c) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: c.muted),
      filled: true,
      fillColor: c.background,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.border.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.border.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c.error, width: 1.5),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;
  final ColorTokens c;
  const _FormLabel(this.text, this.c);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: c.body)),
    );
  }
}
