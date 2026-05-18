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

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../data/models/pt_service_model.dart';
import '../../data/services/pt_service_service.dart';
import '../../domain/entities/pt_package_entity.dart';
import '../bloc/packages/pt_package_bloc.dart';
import '../bloc/packages/pt_package_state.dart';
import '../bloc/packages/pt_package_bloc.dart'
    hide PtPackageBloc, PtPackageState, PtPackageError, PtPackageLoading, PtPackageMutating, PtPackageLoaded;

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
              widget.isAdmin ? 'All Packages' : 'My Packages',
              style: TextStyle(color: tokens.colors.label),
            ),
            backgroundColor: tokens.colors.surface,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: tokens.colors.primary),
                onPressed: () => _showCreateDialog(context, tokens),
              ),
            ],
          ),
          body: _buildBody(state, tokens),
        );
      },
    );
  }

  Widget _buildBody(PtPackageState state, dynamic tokens) {
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
            ElevatedButton(onPressed: _load, child: const Text('Retry')),
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
                'Show Deactivated',
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
                  'No packages found.',
                  style: TextStyle(color: tokens.colors.muted),
                ),
              ),
            ),
          ...packages.map(
            (pkg) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PackageCard(
                package:     pkg,
                trainerName: _trainerName(pkg.trainerId),
                showBadge:   widget.isAdmin,
                onEdit:      (p) => _showEditDialog(context, p, tokens),
                onDeactivate:(p) => _confirmDeactivate(context, p),
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
                'Deactivated Packages',
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
                  'No deactivated packages.',
                  style: TextStyle(color: tokens.colors.muted, fontSize: 13),
                ),
              ),
            ...inactivePackages.map(
              (pkg) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PackageCard(
                  package:     pkg,
                  trainerName: _trainerName(pkg.trainerId),
                  showBadge:   widget.isAdmin,
                  onEdit:      null,
                  onDeactivate: null,
                  onReactivate: (p) => _confirmReactivate(context, p),
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
        title: const Text('Deactivate Package'),
        content: Text('Deactivate "${pkg.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _bloc.add(PtPackageDeactivateRequested(pkg.id));
              Navigator.pop(context);
            },
            child: const Text('Deactivate',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmReactivate(BuildContext context, PtPackageEntity pkg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reactivate Package'),
        content: Text('Reactivate "${pkg.name}"? It will become visible to members again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _bloc.add(PtPackageUpdateRequested(
                packageId: pkg.id,
                body: {'isActive': true},
              ));
              Navigator.pop(context);
            },
            child: const Text('Reactivate'),
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
                      'Inactive',
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
                  'By $trainerName',
                  style: TextStyle(
                    color: tokens.colors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            _infoRow(tokens, '${package.numberOfSessions} sessions',
                Icons.fitness_center),
            _infoRow(tokens,
                '${package.minDaysPerWeek}–${package.maxDaysPerWeek} days/week',
                Icons.calendar_today),
            _infoRow(tokens, '${package.sessionDurationMinutes} min/session',
                Icons.timer),
            _infoRow(tokens, '${package.daysAvailable} days valid',
                Icons.date_range),
            if (package.maxConcurrentSessions > 1)
              _infoRow(tokens,
                  'Max ${package.maxConcurrentSessions} concurrent',
                  Icons.people),
            _infoRow(tokens,
                package.salePrice != null
                    ? '\$${package.salePrice!.toStringAsFixed(2)} (was \$${package.price.toStringAsFixed(2)})'
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
                    label: const Text('Edit'),
                  ),
                if (onDeactivate != null) ...[
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () => onDeactivate!(package),
                    icon: Icon(Icons.delete_outline,
                        size: 16, color: tokens.colors.danger),
                    label: Text('Deactivate',
                        style: TextStyle(color: tokens.colors.danger)),
                  ),
                ],
                if (onReactivate != null)
                  TextButton.icon(
                    onPressed: () => onReactivate!(package),
                    icon: Icon(Icons.refresh_rounded,
                        size: 16, color: tokens.colors.primary),
                    label: Text('Reactivate',
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
    return AlertDialog(
      title: Text(isEdit ? 'Edit Package' : 'New Package'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Trainer picker (admin only) ────────────────────────────
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
                  const SizedBox(height: 12),
                ],

                // ── Package Name ───────────────────────────────────────────
                _field(_name, 'Package Name',
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null),

                // ── Package Type (NOT NULL in DB) ──────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField<String>(
                    value: _packageType,
                    decoration:
                        const InputDecoration(labelText: 'Package Type *'),
                    items: _kPackageTypes.map((t) {
                      return DropdownMenuItem(value: t, child: Text(t));
                    }).toList(),
                    onChanged: (v) =>
                        setState(() => _packageType = v ?? _kPackageTypes.first),
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),

                // ── Number of Sessions ─────────────────────────────────────
                _field(_sessions, 'Number of Sessions',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    int.tryParse(v ?? '') == null ? 'Enter a number' : null),

                // ── Session Duration ───────────────────────────────────────
                _field(_duration, 'Session Duration (min)',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    int.tryParse(v ?? '') == null ? 'Enter a number' : null),

                // ── Days Available (validity, NOT NULL in DB) ──────────────
                _field(_daysAvailable, 'Days Available (validity period) *',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    int.tryParse(v ?? '') == null ? 'Enter a number' : null),

                // ── Min / Max Days per Week ────────────────────────────────
                _field(_minDays, 'Min Days/Week',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    int.tryParse(v ?? '') == null ? 'Enter a number' : null),
                _field(_maxDays, 'Max Days/Week',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    int.tryParse(v ?? '') == null ? 'Enter a number' : null),

                // ── Max Concurrent Sessions (nullable in DB) ───────────────
                _field(_maxConcurrent, 'Max Concurrent Sessions',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                    int.tryParse(v ?? '') == null ? 'Enter a number' : null),

                // ── Price / Sale Price ─────────────────────────────────────
                _field(_price, 'Price',
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) =>
                    double.tryParse(v ?? '') == null
                        ? 'Enter a price'
                        : null),
                _field(_salePrice, 'Sale Price (optional)',
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true)),

                // ── PT Service (FK → pt_services, nullable) ────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _servicesLoading
                      ? const Center(
                          child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2)))
                      : DropdownButtonFormField<int?>(
                          value: _selectedServiceId,
                          decoration: const InputDecoration(
                              labelText: 'Linked PT Service (optional)'),
                          hint: const Text('None'),
                          items: [
                            const DropdownMenuItem<int?>(
                                value: null, child: Text('None')),
                            ..._services.map((s) => DropdownMenuItem<int?>(
                                value: s.serviceId,
                                child: Text(s.name))),
                          ],
                          onChanged: (v) =>
                              setState(() => _selectedServiceId = v),
                        ),
                ),

                // ── isActive toggle (edit mode only) ──────────────────────
                if (isEdit) ...[
                  SwitchListTile(
                    title: const Text('Active'),
                    subtitle: const Text('Uncheck to deactivate this package'),
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ],
            ),
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
      if (_selectedServiceId != null)
        'ptServiceId': _selectedServiceId,              // ← was missing
      if (isEdit) 'isActive': _isActive,               // ← edit-only
    };

    widget.onSubmit(trainerId, body);
  }
}
