// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_packages_screen.dart
//
// FIX SUMMARY:
//   1. Screen receives isAdmin + trainers list.
//   2. ADMIN: fetches packages for ALL trainers and shows a "By <Trainer>"
//      badge on each card. "New Package" dialog lets admin assign to any trainer.
//   3. TRAINER: fetches only their own packages. No trainer picker shown.
//   4. Loading-forever bug fixed — _cachedPackages shows stale data while
//      re-loading after mutation (no more blank flash).
// =============================================================================

import 'package:build4allgym/features/admin/pt_dashboard/data/models/pt_package_model.dart';
import 'package:build4allgym/features/admin/pt_dashboard/data/models/pt_service_model.dart';
import 'package:build4allgym/features/admin/pt_dashboard/data/services/pt_service_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../admin/trainers/data/models/admin_trainer_card_model.dart';
import '../../data/services/pt_package_service.dart';
import '../bloc/pt_package_bloc.dart';

// ── Internal model: package + trainer name ─────────────────────────────────

class _PackageWithTrainer {
  final PtPackageModel         package;
  final AdminTrainerCardModel  trainer;
  _PackageWithTrainer({required this.package, required this.trainer});
}

// =============================================================================

class TrainerPackagesScreen extends StatefulWidget {
  final int  tenantId;
  final int  branchId;
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
  final PtPackageService _svc = PtPackageService();

  /// Merged list for admin (all trainers' packages).
  List<_PackageWithTrainer> _allPackages   = [];
  bool    _loading = false;
  String? _error;

  // Single-trainer bloc for non-admin
  PtPackageBloc?      _trainerBloc;
  List<PtPackageModel> _cachedPackages = [];

  @override
  void initState() {
    super.initState();
    if (widget.isAdmin) {
      _loadAllPackages();
    } else {
      _trainerBloc = PtPackageBloc(_svc)
        ..add(LoadPackages(
          trainerId: widget.trainerId,
          tenantId:  widget.tenantId,
          branchId:  widget.branchId,
        ));
    }
  }

  @override
  void dispose() {
    _trainerBloc?.close();
    super.dispose();
  }

  // ── Admin: load packages for every trainer ──────────────────────────────

  Future<void> _loadAllPackages() async {
    if (!mounted) return;
    setState(() { _loading = true; _error = null; });
    try {
      final List<_PackageWithTrainer> merged = [];
      for (final trainer in widget.trainers) {
        final pkgs = await _svc.getPackages(
          trainerId: trainer.trainerId,
          tenantId:  widget.tenantId,
          branchId:  widget.branchId,
        );
        for (final p in pkgs) {
          merged.add(_PackageWithTrainer(package: p, trainer: trainer));
        }
      }
      if (!mounted) return;
      setState(() { _allPackages = merged; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _loading = false; _error = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final cs     = tokens.colors;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Packages',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => _showCreateDialog(context, cs),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Package', style: TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
      body: widget.isAdmin ? _buildAdminBody(cs) : _buildTrainerBody(cs),
    );
  }

  // ── ADMIN body ───────────────────────────────────────────────────────────

  Widget _buildAdminBody(dynamic cs) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                color: Color(0xFFEF4444), size: 48),
            const SizedBox(height: 12),
            Text(_error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF6B7280))),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllPackages,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_allPackages.isEmpty) {
      return const Center(
        child: Text('No packages yet.',
            style: TextStyle(color: Color(0xFF6B7280))),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allPackages.length,
      itemBuilder: (_, i) {
        final item = _allPackages[i];
        return _PackageCard(
          pkg:          item.package,
          trainerName:  item.trainer.fullName,  // ← show trainer badge
          onEdit:       () => _showEditDialog(context, item.package, item.trainer.trainerId),
          onDeactivate: () => _deactivatePackage(item.package.id),
        );
      },
    );
  }

  // ── TRAINER body (bloc-based) ─────────────────────────────────────────────

  Widget _buildTrainerBody(dynamic cs) {
    return BlocConsumer<PtPackageBloc, PtPackageState>(
      bloc: _trainerBloc,
      listener: (context, state) {
        if (state is PtPackageLoaded) {
          setState(() => _cachedPackages = state.packages);
        }
        if (state is PtPackageMutated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Package saved.'),
              backgroundColor: Color(0xFF22C55E),
            ),
          );
          _trainerBloc!.add(LoadPackages(
            trainerId: widget.trainerId,
            tenantId:  widget.tenantId,
            branchId:  widget.branchId,
          ));
        }
        if (state is PtPackageError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if ((state is PtPackageInitial ||
            state is PtPackageLoading ||
            state is PtPackageMutating ||
            state is PtPackageMutated) &&
            _cachedPackages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PtPackageError && _cachedPackages.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: Color(0xFFEF4444), size: 48),
                const SizedBox(height: 12),
                Text(state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF6B7280))),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _trainerBloc!.add(LoadPackages(
                    trainerId: widget.trainerId,
                    tenantId:  widget.tenantId,
                    branchId:  widget.branchId,
                  )),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        final packages =
        state is PtPackageLoaded ? state.packages : _cachedPackages;
        if (packages.isEmpty) {
          return const Center(
            child: Text('No packages yet.',
                style: TextStyle(color: Color(0xFF6B7280))),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: packages.length,
          itemBuilder: (_, i) => _PackageCard(
            pkg:          packages[i],
            trainerName:  null,   // trainer sees own packages — no badge needed
            onEdit:       () => _showEditDialog(
                context, packages[i], widget.trainerId),
            onDeactivate: () {
              _trainerBloc!.add(DeactivatePackage(packages[i].id));
            },
          ),
        );
      },
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  void _showCreateDialog(BuildContext context, dynamic cs) {
    showDialog(
      context: context,
      builder: (_) => _CreatePackageDialog(
        isAdmin:   widget.isAdmin,
        trainers:  widget.trainers,
        defaultTrainerId: widget.trainerId,
        tenantId:  widget.tenantId,
        branchId:  widget.branchId,
        svc:       _svc,
        onSaved: () {
          Navigator.of(context).pop();
          if (widget.isAdmin) {
            _loadAllPackages();
          } else {
            _trainerBloc!.add(LoadPackages(
              trainerId: widget.trainerId,
              tenantId:  widget.tenantId,
              branchId:  widget.branchId,
            ));
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Package created.'),
              backgroundColor: Color(0xFF22C55E),
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(
      BuildContext context,
      PtPackageModel pkg,
      int trainerId,
      ) {
    showDialog(
      context: context,
      builder: (_) => _EditPackageDialog(
        pkg:       pkg,
        trainerId: trainerId,
        svc:       _svc,
        onSaved: () {
          Navigator.of(context).pop();
          if (widget.isAdmin) {
            _loadAllPackages();
          } else {
            _trainerBloc!.add(LoadPackages(
              trainerId: widget.trainerId,
              tenantId:  widget.tenantId,
              branchId:  widget.branchId,
            ));
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Package updated.'),
              backgroundColor: Color(0xFF22C55E),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deactivatePackage(int id) async {
    try {
      await _svc.deactivatePackage(id);
      if (widget.isAdmin) {
        _loadAllPackages();
      } else {
        _trainerBloc!.add(DeactivatePackage(id));
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Package deactivated.'),
            backgroundColor: Color(0xFF6B7280),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

// ── Package card ──────────────────────────────────────────────────────────────

class _PackageCard extends StatelessWidget {
  final PtPackageModel pkg;
  final String?        trainerName;  // null = don't show badge
  final VoidCallback   onEdit;
  final VoidCallback   onDeactivate;

  const _PackageCard({
    super.key,
    required this.pkg,
    required this.trainerName,
    required this.onEdit,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pkg.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pkg.packageType,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      // Trainer badge — only for admin view
                      if (trainerName != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person_outline,
                                  size: 12, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                trainerName!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (pkg.active)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Active',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'edit') onEdit();
                        if (v == 'deactivate') onDeactivate();
                      },
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                            value: 'edit', child: Text('Edit')),
                        if (pkg.active)
                          const PopupMenuItem(
                              value: 'deactivate',
                              child: Text('Deactivate')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _StatChip(
                  icon: Icons.fitness_center,
                  value: '${pkg.numberOfSessions}',
                  label: 'Sessions',
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.calendar_today,
                  value: '${pkg.daysAvailable}d',
                  label: 'Duration',
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.attach_money,
                  value: '\$${pkg.price.toStringAsFixed(0)}',
                  label: 'Price',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String   value;
  final String   label;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF4F46E5)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1A1A2E))),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }
}

// ── Create Package Dialog ─────────────────────────────────────────────────────

class _CreatePackageDialog extends StatefulWidget {
  final bool   isAdmin;
  final List<AdminTrainerCardModel> trainers;
  final int    defaultTrainerId;
  final int    tenantId;
  final int    branchId;
  final PtPackageService svc;
  final VoidCallback onSaved;

  const _CreatePackageDialog({
    required this.isAdmin,
    required this.trainers,
    required this.defaultTrainerId,
    required this.tenantId,
    required this.branchId,
    required this.svc,
    required this.onSaved,
  });

  @override
  State<_CreatePackageDialog> createState() => _CreatePackageDialogState();
}

class _CreatePackageDialogState extends State<_CreatePackageDialog> {
  final _nameCtrl        = TextEditingController();
  final _sessionsCtrl    = TextEditingController(text: '12');
  final _daysCtrl        = TextEditingController(text: '84');
  final _priceCtrl       = TextEditingController();
  final _minPerWeekCtrl  = TextEditingController(text: '1');
  final _maxPerWeekCtrl  = TextEditingController(text: '3');
  bool _saving = false;
  late int _selectedTrainerId;

  @override
  void initState() {
    super.initState();
    _selectedTrainerId = widget.defaultTrainerId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sessionsCtrl.dispose();
    _daysCtrl.dispose();
    _priceCtrl.dispose();
    _minPerWeekCtrl.dispose();
    _maxPerWeekCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _priceCtrl.text.trim().isEmpty) {
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.svc.createPackage(
        trainerId: _selectedTrainerId,
        tenantId:  widget.tenantId,
        branchId:  widget.branchId,
        body: {
          'name':           _nameCtrl.text.trim(),
          'packageType':    'CUSTOM',
          'numberOfSessions': int.tryParse(_sessionsCtrl.text) ?? 12,
          'daysAvailable':  int.tryParse(_daysCtrl.text) ?? 84,
          'minDaysPerWeek': int.tryParse(_minPerWeekCtrl.text) ?? 1,
          'maxDaysPerWeek': int.tryParse(_maxPerWeekCtrl.text) ?? 3,
          'price':          double.tryParse(_priceCtrl.text) ?? 0.0,
          'active':         true,
        },
      );
      widget.onSaved();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Package'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Admin: trainer picker
            if (widget.isAdmin && widget.trainers.isNotEmpty) ...[
              DropdownButtonFormField<int>(
                value: _selectedTrainerId,
                decoration: const InputDecoration(
                    labelText: 'Assign to Trainer'),
                items: widget.trainers
                    .map((t) => DropdownMenuItem(
                  value: t.trainerId,
                  child: Text(t.fullName),
                ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedTrainerId = v);
                },
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Package Name'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sessionsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Sessions'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _daysCtrl,
                    keyboardType: TextInputType.number,
                    decoration:
                    const InputDecoration(labelText: 'Days valid'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _minPerWeekCtrl,
                    keyboardType: TextInputType.number,
                    decoration:
                    const InputDecoration(labelText: 'Min/week'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _maxPerWeekCtrl,
                    keyboardType: TextInputType.number,
                    decoration:
                    const InputDecoration(labelText: 'Max/week'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5)),
          child: _saving
              ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white))
              : const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// ── Edit Package Dialog ───────────────────────────────────────────────────────

class _EditPackageDialog extends StatefulWidget {
  final PtPackageModel    pkg;
  final int               trainerId;
  final PtPackageService  svc;
  final VoidCallback      onSaved;

  const _EditPackageDialog({
    required this.pkg,
    required this.trainerId,
    required this.svc,
    required this.onSaved,
  });

  @override
  State<_EditPackageDialog> createState() => _EditPackageDialogState();
}

class _EditPackageDialogState extends State<_EditPackageDialog> {
  late TextEditingController _nameCtrl;
  late TextEditingController _sessionsCtrl;
  late TextEditingController _priceCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController(text: widget.pkg.name);
    _sessionsCtrl =
        TextEditingController(text: '${widget.pkg.numberOfSessions}');
    _priceCtrl    = TextEditingController(text: '${widget.pkg.price}');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sessionsCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.svc.updatePackage(widget.pkg.id, {
        'name':             _nameCtrl.text.trim(),
        'numberOfSessions': int.tryParse(_sessionsCtrl.text) ??
            widget.pkg.numberOfSessions,
        'price': double.tryParse(_priceCtrl.text) ?? widget.pkg.price,
      });
      widget.onSaved();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Package'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Package Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _sessionsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sessions'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5)),
          child: _saving
              ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white))
              : const Text('Update',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}