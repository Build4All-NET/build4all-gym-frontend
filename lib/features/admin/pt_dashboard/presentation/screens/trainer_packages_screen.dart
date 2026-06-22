// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_packages_screen.dart
//
// CHANGES vs previous version:
//   - _PackageFormDialog now includes ALL fields required / expected by the DB
//     table pt_packages:
//
//     ADDED fields:
//       packageType         (varchar NOT NULL) — dropdown: INDIVIDUAL / GROUP /
//                           ONLINE / CORPORATE
//       daysAvailable       (integer NOT NULL) — how many days the package is
//                           valid for (e.g. 30, 60, 90)
//       maxConcurrentSessions (integer nullable) — max parallel sessions (default 1)
//       ptServiceId         (bigint nullable, FK → pt_services) — links the
//                           package to a specific PT service; loaded
//                           asynchronously via PtServiceService
//       isActive            (boolean NOT NULL) — toggle shown in edit mode only;
//                           for new packages always true
//
//     These were previously missing, meaning create/update would send them
//     as null/empty and the backend would either reject or default incorrectly.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/app_toast.dart';
import '../../../../../core/theme/app_theme_tokens.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../data/models/pt_service_model.dart';
import '../../data/services/pt_service_service.dart';
import '../../domain/entities/pt_package_entity.dart';
import '../bloc/packages/pt_package_bloc.dart';
import '../bloc/packages/pt_package_state.dart';
import '../bloc/packages/pt_package_bloc.dart'
    hide PtPackageBloc, PtPackageState, PtPackageError, PtPackageLoading, PtPackageMutating, PtPackageLoaded;
import '../widgets/pt_form_dialog_kit.dart';

// ── Package type options (must match backend enum) ────────────────────────────
const _kPackageTypes = ['INDIVIDUAL', 'GROUP', 'ONLINE', 'CORPORATE'];

class TrainerPackagesScreen extends StatefulWidget {
  final int  tenantId;
  final int  branchId;
  /// 0 = admin/owner (all-trainers mode), non-zero = that trainer only
  final int  trainerId;
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;

  const TrainerPackagesScreen({
    super.key,
    required this.tenantId,
    required this.branchId,
    required this.trainerId,
    required this.isAdmin,
    required this.trainers,
  });

  @override
  State<TrainerPackagesScreen> createState() => _TrainerPackagesScreenState();
}

class _TrainerPackagesScreenState extends State<TrainerPackagesScreen> {
  late final PtPackageBloc _bloc;
  bool _showDeactivated = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<PtPackageBloc>();
    _load();
  }

  void _load() {
    _bloc.add(PtPackagesLoadRequested(
      trainerId: widget.isAdmin ? null : widget.trainerId,
      tenantId:  widget.tenantId,
      branchId:  widget.branchId,
    ));
  }

  void _loadInactive() {
    _bloc.add(PtInactivePackagesLoadRequested(
      trainerId: widget.isAdmin ? null : widget.trainerId,
      tenantId:  widget.tenantId,
      branchId:  widget.branchId,
    ));
  }

  void _toggleDeactivated(bool value) {
    setState(() => _showDeactivated = value);
    if (value) _loadInactive();
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

  /// Only Admin/Owner/Manager can create/edit/deactivate packages — the
  /// backend rejects writes from anyone else (e.g. Reception, who can still
  /// view this screen in admin-mode). Checks the real JWT role, not the loose
  /// "admin-mode view" flag (widget.isAdmin), which also covers Reception.
  bool _canManage(BuildContext context) =>
      context.read<AdminProfileCubit>().state.isAdminRole;

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final canManage = _canManage(context);

    return BlocConsumer<PtPackageBloc, PtPackageState>(
      listener: (ctx, state) {
        if (state is PtPackageMutationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is PtPackageError) {
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
              widget.isAdmin ? AppLocalizations.of(context)!.trainer_packagesAllTitle : AppLocalizations.of(context)!.trainer_packagesMyTitle,
              style: TextStyle(color: tokens.colors.label),
            ),
            backgroundColor: tokens.colors.surface,
            elevation: 0,
            actions: [
              if (canManage)
                IconButton(
                  icon: Icon(Icons.add, color: tokens.colors.primary),
                  onPressed: () => _showCreateDialog(context, tokens),
                ),
            ],
          ),
          body: _buildBody(context, state, tokens, canManage),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PtPackageState state, dynamic tokens, bool canManage) {
    if (state is PtPackageLoading || state is PtPackageMutating || state is PtPackageMutationSuccess) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PtPackageError) {
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

    final packages =
        state is PtPackageLoaded ? state.packages : <PtPackageEntity>[];
    final inactivePackages =
        state is PtPackageLoaded ? state.inactivePackages : <PtPackageEntity>[];

    return RefreshIndicator(
      onRefresh: () async {
        _load();
        if (_showDeactivated) _loadInactive();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Toggle row ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.trainer_showDeactivated,
                style: TextStyle(color: tokens.colors.body, fontSize: 14),
              ),
              Switch(
                value: _showDeactivated,
                onChanged: _toggleDeactivated,
                activeColor: tokens.colors.primary,
              ),
            ],
          ),
          const SizedBox(height: 4),

          // ── Active packages ───────────────────────────────────────────────
          if (packages.isEmpty && !_showDeactivated)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.trainer_noPackagesFound,
                  style: TextStyle(color: tokens.colors.muted),
                ),
              ),
            ),
          ...packages.map(
            (pkg) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PackageCard(
                package:     pkg,
                trainerName: _trainerName(pkg.trainerId, context),
                showBadge:   widget.isAdmin,
                onEdit:      canManage ? (p) => _showEditDialog(context, p, tokens) : null,
                onDeactivate: canManage ? (p) => _confirmDeactivate(context, p) : null,
                onReactivate: null,
              ),
            ),
          ),

          // ── Deactivated section ───────────────────────────────────────────
          if (_showDeactivated) ...[
            const SizedBox(height: 8),
            Divider(color: tokens.colors.border),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                AppLocalizations.of(context)!.trainer_deactivatedPackages,
                style: TextStyle(
                  color: tokens.colors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (inactivePackages.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  AppLocalizations.of(context)!.trainer_noDeactivatedPackages,
                  style: TextStyle(color: tokens.colors.muted, fontSize: 13),
                ),
              ),
            ...inactivePackages.map(
              (pkg) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PackageCard(
                  package:     pkg,
                  trainerName: _trainerName(pkg.trainerId, context),
                  showBadge:   widget.isAdmin,
                  onEdit:      null,
                  onDeactivate: null,
                  onReactivate: canManage ? (p) => _confirmReactivate(context, p) : null,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Dialogs ────────────────────────────────────────────────────────────────

  void _showCreateDialog(BuildContext context, dynamic tokens) {
    showDialog(
      context: context,
      builder: (_) => _PackageFormDialog(
        isAdmin:          widget.isAdmin,
        trainers:         widget.trainers,
        defaultTrainerId: widget.trainerId,
        tenantId:         widget.tenantId,
        onSubmit: (trainerId, body) {
          _bloc.add(PtPackageCreateRequested(
            trainerId: trainerId,
            tenantId:  widget.tenantId,
            branchId:  widget.branchId,
            body:      body,
          ));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditDialog(
      BuildContext context,
      PtPackageEntity pkg,
      dynamic tokens,
      ) {
    showDialog(
      context: context,
      builder: (_) => _PackageFormDialog(
        isAdmin:          widget.isAdmin,
        trainers:         widget.trainers,
        defaultTrainerId: pkg.trainerId,
        tenantId:         widget.tenantId,
        initialPackage:   pkg,
        onSubmit: (_, body) {
          _bloc.add(PtPackageUpdateRequested(
            packageId: pkg.id,
            body:      body,
          ));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmDeactivate(BuildContext context, PtPackageEntity pkg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.trainer_deactivatePackageTitle),
        content: Text(AppLocalizations.of(context)!.trainer_deactivatePackageMessage(pkg.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.general_cancel),
          ),
          TextButton(
            onPressed: () {
              _bloc.add(PtPackageDeactivateRequested(pkg.id));
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.trainer_deactivateButton,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmReactivate(BuildContext context, PtPackageEntity pkg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.trainer_reactivatePackageTitle),
        content: Text(AppLocalizations.of(context)!.trainer_reactivatePackageMessage(pkg.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.general_cancel),
          ),
          TextButton(
            onPressed: () {
              _bloc.add(PtPackageUpdateRequested(
                packageId: pkg.id,
                body: {'isActive': true},
              ));
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.trainer_reactivateButton),
          ),
        ],
      ),
    );
  }
}

// ── Package card ───────────────────────────────────────────────────────────────

class _PackageCard extends StatelessWidget {
  final PtPackageEntity package;
  final String trainerName;
  final bool showBadge;
  final void Function(PtPackageEntity)? onEdit;
  final void Function(PtPackageEntity)? onDeactivate;
  final void Function(PtPackageEntity)? onReactivate;

  const _PackageCard({
    required this.package,
    required this.trainerName,
    required this.showBadge,
    required this.onEdit,
    required this.onDeactivate,
    required this.onReactivate,
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
                    package.name,
                    style: TextStyle(
                      color: tokens.colors.label,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (package.packageType.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tokens.colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      package.packageType,
                      style: TextStyle(
                          color: tokens.colors.primary, fontSize: 11),
                    ),
                  ),
                const SizedBox(width: 6),
                if (!package.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tokens.colors.muted.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.trainer_inactiveBadge,
                      style: TextStyle(
                          color: tokens.colors.muted, fontSize: 11),
                    ),
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
            const SizedBox(height: 8),
            _infoRow(tokens, AppLocalizations.of(context)!.trainer_packageSessionsCount(package.numberOfSessions),
                Icons.fitness_center),
            _infoRow(tokens,
                AppLocalizations.of(context)!.trainer_packageDaysPerWeekRange(package.minDaysPerWeek, package.maxDaysPerWeek),
                Icons.calendar_today),
            _infoRow(tokens, AppLocalizations.of(context)!.memberHomeDurationMinutes(package.sessionDurationMinutes),
                Icons.timer),
            _infoRow(tokens, AppLocalizations.of(context)!.trainer_packageDaysValid(package.daysAvailable),
                Icons.date_range),
            if (package.maxConcurrentSessions > 1)
              _infoRow(tokens,
                  AppLocalizations.of(context)!.trainer_maxConcurrent(package.maxConcurrentSessions),
                  Icons.people),
            _infoRow(tokens,
                package.salePrice != null
                    ? AppLocalizations.of(context)!.trainer_packagePriceWasPrice(
                        package.salePrice!.toStringAsFixed(2), package.price.toStringAsFixed(2))
                    : '\$${package.price.toStringAsFixed(2)}',
                Icons.attach_money),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onEdit != null)
                  TextButton.icon(
                    onPressed: () => onEdit!(package),
                    icon: const Icon(Icons.edit, size: 16),
                    label: Text(AppLocalizations.of(context)!.admin_members_actionEdit),
                  ),
                if (onDeactivate != null) ...[
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () => onDeactivate!(package),
                    icon: Icon(Icons.delete_outline,
                        size: 16, color: tokens.colors.danger),
                    label: Text(AppLocalizations.of(context)!.trainer_deactivateButton,
                        style: TextStyle(color: tokens.colors.danger)),
                  ),
                ],
                if (onReactivate != null)
                  TextButton.icon(
                    onPressed: () => onReactivate!(package),
                    icon: Icon(Icons.refresh_rounded,
                        size: 16, color: tokens.colors.primary),
                    label: Text(AppLocalizations.of(context)!.trainer_reactivateButton,
                        style: TextStyle(color: tokens.colors.primary)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(dynamic tokens, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: tokens.colors.muted),
          const SizedBox(width: 6),
          Text(label,
              style:
                  TextStyle(color: tokens.colors.body, fontSize: 13)),
        ],
      ),
    );
  }
}

// ── Package form dialog ────────────────────────────────────────────────────────
//
// Handles both CREATE and EDIT.
// For CREATE:  isActive defaults to true (not shown in UI).
// For EDIT:    isActive toggle is shown so the admin can re-activate a package
//              without going through the deactivate flow.
//
// New fields added per DB schema audit:
//   packageType         — dropdown (pt_packages.package_type, NOT NULL)
//   daysAvailable       — int      (pt_packages.days_available, NOT NULL)
//   maxConcurrentSessions — int    (pt_packages.max_concurrent_sessions, nullable)
//   ptServiceId         — dropdown (pt_packages.pt_service_id, FK → pt_services)
//   isActive            — switch   (pt_packages.is_active, edit-only)

class _PackageFormDialog extends StatefulWidget {
  final bool isAdmin;
  final List<AdminTrainerCardModel> trainers;
  final int defaultTrainerId;
  final int tenantId;
  final PtPackageEntity? initialPackage;
  final void Function(int trainerId, Map<String, dynamic> body) onSubmit;

  const _PackageFormDialog({
    required this.isAdmin,
    required this.trainers,
    required this.defaultTrainerId,
    required this.tenantId,
    this.initialPackage,
    required this.onSubmit,
  });

  @override
  State<_PackageFormDialog> createState() => _PackageFormDialogState();
}

class _PackageFormDialogState extends State<_PackageFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // ── Text controllers ───────────────────────────────────────────────────────
  late final TextEditingController _name;
  late final TextEditingController _sessions;
  late final TextEditingController _duration;
  late final TextEditingController _daysAvailable;
  late final TextEditingController _minDays;
  late final TextEditingController _maxDays;
  late final TextEditingController _maxConcurrent;
  late final TextEditingController _price;
  late final TextEditingController _salePrice;

  // ── Dropdown / toggle state ────────────────────────────────────────────────
  int?    _selectedTrainerId;
  String  _packageType = _kPackageTypes.first;
  bool    _isActive    = true;

  // ── PT Services (for ptServiceId dropdown) ─────────────────────────────────
  List<PtServiceModel> _services        = [];
  bool                 _servicesLoading = false;
  int?                 _selectedServiceId;

  @override
  void initState() {
    super.initState();
    final p        = widget.initialPackage;
    _name          = TextEditingController(text: p?.name ?? '');
    _sessions      = TextEditingController(
        text: p != null ? '${p.numberOfSessions}' : '');
    _duration      = TextEditingController(
        text: p != null ? '${p.sessionDurationMinutes}' : '60');
    _daysAvailable = TextEditingController(
        text: p != null ? '${p.daysAvailable}' : '30');
    _minDays       = TextEditingController(
        text: p != null ? '${p.minDaysPerWeek}' : '1');
    _maxDays       = TextEditingController(
        text: p != null ? '${p.maxDaysPerWeek}' : '3');
    _maxConcurrent = TextEditingController(
        text: p != null ? '${p.maxConcurrentSessions}' : '1');
    _price         = TextEditingController(
        text: p != null ? '${p.price}' : '');
    _salePrice     = TextEditingController(
        text: p?.salePrice != null ? '${p!.salePrice}' : '');

    // Only pre-select the trainer if they still exist in the active list.
    // A deleted trainer's ID won't be in the items list, which causes a
    // Flutter assertion error on the DropdownButtonFormField.
    final trainerStillActive = widget.trainers.any(
      (t) => t.trainerId == widget.defaultTrainerId,
    );
    _selectedTrainerId = (widget.defaultTrainerId != 0 && trainerStillActive)
        ? widget.defaultTrainerId
        : null;
    _packageType = (p?.packageType.isNotEmpty == true &&
            _kPackageTypes.contains(p?.packageType))
        ? p!.packageType
        : _kPackageTypes.first;
    _isActive          = p?.isActive ?? true;
    _selectedServiceId = p?.ptServiceId;

    _loadServices();
  }

  @override
  void dispose() {
    _name.dispose();
    _sessions.dispose();
    _duration.dispose();
    _daysAvailable.dispose();
    _minDays.dispose();
    _maxDays.dispose();
    _maxConcurrent.dispose();
    _price.dispose();
    _salePrice.dispose();
    super.dispose();
  }

  // ── Load PT services for the ptServiceId dropdown ──────────────────────────

  Future<void> _loadServices() async {
    setState(() => _servicesLoading = true);
    try {
      final list = await PtServiceService()
          .getServices(tenantId: widget.tenantId);
      if (mounted) {
        setState(() {
          _services        = list.where((s) => s.isActive).toList();
          _servicesLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _servicesLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialPackage != null;
    final l10n   = AppLocalizations.of(context)!;
    final c      = context.read<ThemeCubit>().state.tokens.colors;

    return PtFormDialogScaffold(
      header: PtDialogHeader(
        icon:     Icons.card_membership_rounded,
        title:    isEdit ? l10n.trainer_editPackage : l10n.trainer_newPackage,
        subtitle: isEdit ? l10n.trainer_editPackageSubtitle : l10n.trainer_newPackageSubtitle,
        onClose:  () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Trainer picker (admin only) ────────────────────────────
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
            _field(c, _name, l10n.trainer_packageNameLabel,
                icon: Icons.badge_outlined,
                validator: (v) =>
                v == null || v.isEmpty ? l10n.trainer_requiredField : null),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DropdownButtonFormField<String>(
                value: _packageType,
                decoration: ptFieldDecoration(c,
                    label: l10n.trainer_packageTypeLabel,
                    icon: Icons.category_outlined),
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.muted),
                items: _kPackageTypes.map((t) {
                  return DropdownMenuItem(value: t, child: Text(t));
                }).toList(),
                onChanged: (v) =>
                    setState(() => _packageType = v ?? _kPackageTypes.first),
                validator: (v) =>
                v == null || v.isEmpty ? l10n.trainer_requiredField : null,
              ),
            ),

            // ── Sessions & schedule ─────────────────────────────────────
            PtSectionLabel(icon: Icons.event_repeat_rounded, text: l10n.trainer_sectionSessionsSchedule),
            _fieldRow(
              _field(c, _sessions, l10n.trainer_numberOfSessions,
                  icon: Icons.fitness_center_rounded,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                  int.tryParse(v ?? '') == null ? l10n.trainer_enterNumber : null),
              _field(c, _duration, l10n.trainer_sessionDurationMin,
                  icon: Icons.timer_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                  int.tryParse(v ?? '') == null ? l10n.trainer_enterNumber : null),
            ),
            _fieldRow(
              _field(c, _minDays, l10n.trainer_minDaysWeek,
                  icon: Icons.calendar_view_week_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                  int.tryParse(v ?? '') == null ? l10n.trainer_enterNumber : null),
              _field(c, _maxDays, l10n.trainer_maxDaysWeek,
                  icon: Icons.calendar_view_week_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                  int.tryParse(v ?? '') == null ? l10n.trainer_enterNumber : null),
            ),
            _fieldRow(
              _field(c, _daysAvailable, l10n.trainer_daysAvailable,
                  icon: Icons.event_available_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                  int.tryParse(v ?? '') == null ? l10n.trainer_enterNumber : null),
              _field(c, _maxConcurrent, l10n.trainer_maxConcurrentSessions,
                  icon: Icons.groups_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                  int.tryParse(v ?? '') == null ? l10n.trainer_enterNumber : null),
            ),

            // ── Pricing ──────────────────────────────────────────────────
            PtSectionLabel(icon: Icons.payments_outlined, text: l10n.trainer_sectionPricing),
            _fieldRow(
              _field(c, _price, l10n.trainer_priceLabel,
                  icon: Icons.attach_money_rounded,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) =>
                  double.tryParse(v ?? '') == null
                      ? l10n.trainer_enterPrice
                      : null),
              _field(c, _salePrice, l10n.trainer_salePriceOptional,
                  icon: Icons.sell_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            ),

            // ── PT Service (FK → pt_services, required) ─────────────────
            // Required: the package's session commission % is resolved
            // from this service's commissionPercentage.
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _servicesLoading
                  ? const Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)))
                  : DropdownButtonFormField<int?>(
                      value: _selectedServiceId,
                      decoration: ptFieldDecoration(c,
                          label: l10n.trainer_linkedPtServiceRequired,
                          icon: Icons.link_rounded),
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.muted),
                      items: _services
                          .map((s) => DropdownMenuItem<int?>(
                              value: s.serviceId,
                              child: Text(s.name)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedServiceId = v),
                      validator: (v) =>
                          v == null ? l10n.trainer_selectServiceRequired : null,
                    ),
            ),

            // ── isActive toggle (edit mode only) ──────────────────────
            if (isEdit)
              PtSwitchCard(
                icon: Icons.toggle_on_outlined,
                title: l10n.trainer_activeLabel,
                subtitle: l10n.trainer_uncheckDeactivate,
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
          ],
        ),
      ),
      footer: PtDialogFooter(
        cancelLabel: l10n.general_cancel,
        submitLabel: isEdit ? l10n.editProfileSave : l10n.trainer_createPackage,
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
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller:   ctrl,
      keyboardType: keyboardType,
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

    final isEdit = widget.initialPackage != null;

    final body = <String, dynamic>{
      'name':                   _name.text.trim(),
      'packageType':            _packageType,           // ← was missing
      'numberOfSessions':       int.parse(_sessions.text.trim()),
      'sessionDurationMinutes': int.parse(_duration.text.trim()),
      'daysAvailable':          int.parse(_daysAvailable.text.trim()), // ← was missing
      'minDaysPerWeek':         int.parse(_minDays.text.trim()),
      'maxDaysPerWeek':         int.parse(_maxDays.text.trim()),
      'maxConcurrentSessions':  int.parse(_maxConcurrent.text.trim()), // ← was missing
      'price':                  double.parse(_price.text.trim()),
      if (_salePrice.text.isNotEmpty)
        'salePrice': double.parse(_salePrice.text.trim()),
      'ptServiceId': _selectedServiceId,                // ← now required
      if (isEdit) 'isActive': _isActive,               // ← edit-only
    };

    widget.onSubmit(trainerId, body);
  }
}
