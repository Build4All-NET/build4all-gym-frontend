// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/screens/trainer_packages_screen.dart
//
// DESIGN: Images 3-7 — Packages tab + Create PT Package wizard (4 steps).
//
// This screen is navigated to from:
//   1. Bottom nav "Packages" tab
//   2. Dashboard quick action "Create Package"
//
// The "+ New Package" button opens a 4-step wizard dialog:
//   Step 1 – Basic Info:      Package Name, Package Type, Linked PT Service
//   Step 2 – Training Rules:  Total Sessions, Min/Max Days/Week, Validity
//   Step 3 – Pricing:         Regular Price, Sale Price (optional)
//   Step 4 – Preview summary
//
// TODO: Wire to real backend endpoints when PT Package backend is implemented.
//       Currently uses stub data for the package list.
// =============================================================================

import 'package:build4allgym/features/admin/pt_dashboard/data/models/pt_package_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../data/services/pt_package_service.dart';
import '../bloc/pt_package_bloc.dart';

class TrainerPackagesScreen extends StatefulWidget {
  final int tenantId;
  final int branchId;
  final int trainerId;
  const TrainerPackagesScreen({
    super.key,
    required this.tenantId,
    required this.branchId,
    required this.trainerId,
  });

  @override
  State<TrainerPackagesScreen> createState() => _TrainerPackagesScreenState();
}

class _TrainerPackagesScreenState extends State<TrainerPackagesScreen> {
  late final PtPackageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PtPackageBloc(PtPackageService());
    _bloc.add(LoadPackages(
      trainerId: widget.trainerId,
      tenantId:  widget.tenantId,
      branchId:  widget.branchId,
    ));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final cs = tokens.colors;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Packages',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => _CreatePackageDialog.show(
                context,
                bloc:      _bloc,
                trainerId: widget.trainerId,
                tenantId:  widget.tenantId,
                branchId:  widget.branchId,
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Package',
                  style: TextStyle(fontSize: 13)),
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
      body: BlocConsumer<PtPackageBloc, PtPackageState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is PtPackageMutated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Package saved.'), backgroundColor: Color(0xFF22C55E)),
            );
            _bloc.add(LoadPackages(
              trainerId: widget.trainerId,
              tenantId:  widget.tenantId,
              branchId:  widget.branchId,
            ));
          }
          if (state is PtPackageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is PtPackageLoading) return const Center(child: CircularProgressIndicator());
          if (state is PtPackageLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.packages.length,
              itemBuilder: (_, i) => _PackageCard(pkg: state.packages[i], bloc: _bloc),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Package card ──────────────────────────────────────────────────────────────

class _PackageCard extends StatelessWidget {
  final PtPackageModel pkg;
  final PtPackageBloc bloc;
  const _PackageCard({super.key, required this.pkg, required this.bloc});

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
          // Header gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
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
                    ],
                  ),
                ),
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
              ],
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.inventory_2_outlined,
                      value: '${pkg.numberOfSessions}',
                      label: 'Sessions',
                      color: const Color(0xFF4F46E5),
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.calendar_today_outlined,
                      value: '${pkg.minDaysPerWeek}-${pkg.maxDaysPerWeek}',
                      label: 'Days/Week',
                      color: const Color(0xFF22C55E),
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.access_time_rounded,
                      value: '${pkg.daysAvailable}',
                      label: 'Days',
                      color: const Color(0xFFF59E0B),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Price row
                Row(
                  children: [
                    if (pkg.salePrice != null) ...[
                      Text(
                        '\$${pkg.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      '\$${(pkg.salePrice ?? pkg.price).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                    if (pkg.salePrice != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('SALE',
                            style: TextStyle(
                                color: Color(0xFFDC2626),
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Text(
                        'Save \$${pkg.savings.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Color(0xFF22C55E),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),

                // Duration calculator
                const SizedBox(height: 12),
                Text(
                  '⊙  Duration Calculator',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• ${pkg.minDaysPerWeek} day/week → '
                  '${(pkg.numberOfSessions / pkg.minDaysPerWeek).ceil()} weeks',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                Text(
                  '• ${pkg.maxDaysPerWeek} days/week → '
                  '${(pkg.numberOfSessions / pkg.maxDaysPerWeek).ceil()} weeks',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),

                const SizedBox(height: 12),

                // Edit button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Package'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4F46E5),
                      side: const BorderSide(
                          color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
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
  final String value;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Create Package 4-step dialog ──────────────────────────────────────────────

class _CreatePackageDialog extends StatefulWidget {
  final PtPackageBloc bloc;
  final int trainerId;
  final int tenantId;
  final int branchId;

  const _CreatePackageDialog({
    required this.bloc,
    required this.trainerId,
    required this.tenantId,
    required this.branchId,
  });

  static Future<void> show(
    BuildContext context, {
    required PtPackageBloc bloc,
    required int trainerId,
    required int tenantId,
    required int branchId,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CreatePackageDialog(
        bloc: bloc,
        trainerId: trainerId,
        tenantId: tenantId,
        branchId: branchId,
      ),
    );
  }

  @override
  State<_CreatePackageDialog> createState() => _CreatePackageDialogState();
}

class _CreatePackageDialogState extends State<_CreatePackageDialog> {
  int _step = 0;

  // Step 1 fields
  final _nameCtrl = TextEditingController();
  String? _packageType;
  String? _linkedService;

  // Step 2 fields
  final _totalSessionsCtrl = TextEditingController();
  final _minDaysCtrl = TextEditingController(text: '1');
  final _maxDaysCtrl = TextEditingController(text: '2');
  final _validityCtrl = TextEditingController();

  // Step 3 fields
  final _regularPriceCtrl = TextEditingController();
  final _salePriceCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _totalSessionsCtrl.dispose();
    _minDaysCtrl.dispose();
    _maxDaysCtrl.dispose();
    _validityCtrl.dispose();
    _regularPriceCtrl.dispose();
    _salePriceCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 3) setState(() => _step++);
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) return;
    widget.bloc.add(CreatePackage(
      trainerId: widget.trainerId,
      tenantId: widget.tenantId,
      branchId: widget.branchId,
      data: {
        'name': _nameCtrl.text.trim(),
        'packageType': _packageType ?? 'CUSTOM',
        if (_linkedService != null) 'ptServiceId': int.tryParse(_linkedService!),
        'numberOfSessions': int.tryParse(_totalSessionsCtrl.text) ?? 0,
        'daysAvailable': int.tryParse(_validityCtrl.text) ?? 0,
        'minDaysPerWeek': int.tryParse(_minDaysCtrl.text) ?? 1,
        'maxDaysPerWeek': int.tryParse(_maxDaysCtrl.text) ?? 2,
        'price': double.tryParse(_regularPriceCtrl.text) ?? 0,
        if (_salePriceCtrl.text.isNotEmpty)
          'salePrice': double.tryParse(_salePriceCtrl.text),
        'active': true,
      },
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
              ),
            ),
            const SizedBox(height: 4),

            const Text(
              'Create PT Package',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),

            const SizedBox(height: 20),

            // Step indicator
            _StepIndicator(currentStep: _step),

            const SizedBox(height: 24),

            // Step content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildStep(),
            ),

            const SizedBox(height: 24),

            // Navigation buttons
            Row(
              children: [
                if (_step > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _back,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_step > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _step == 3 ? _submit : _next,
                    icon: _step == 3
                        ? const Icon(Icons.check_circle_outline,
                            size: 18)
                        : const Icon(Icons.arrow_forward_rounded,
                            size: 18),
                    label: Text(
                      _step == 3 ? 'Create Package' : 'Continue',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _step == 3
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _Step1BasicInfo(
          key: const ValueKey(0),
          nameCtrl: _nameCtrl,
          packageType: _packageType,
          linkedService: _linkedService,
          onTypeChanged: (v) => setState(() => _packageType = v),
          onServiceChanged: (v) => setState(() => _linkedService = v),
        );
      case 1:
        return _Step2TrainingRules(
          key: const ValueKey(1),
          totalSessionsCtrl: _totalSessionsCtrl,
          minDaysCtrl: _minDaysCtrl,
          maxDaysCtrl: _maxDaysCtrl,
          validityCtrl: _validityCtrl,
        );
      case 2:
        return _Step3Pricing(
          key: const ValueKey(2),
          regularPriceCtrl: _regularPriceCtrl,
          salePriceCtrl: _salePriceCtrl,
        );
      case 3:
        return _Step4Preview(
          key: const ValueKey(3),
          name: _nameCtrl.text,
          sessions: _totalSessionsCtrl.text,
          minDays: _minDaysCtrl.text,
          maxDays: _maxDaysCtrl.text,
          validity: _validityCtrl.text,
          price: _regularPriceCtrl.text,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Step indicator ────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  static const _labels = [
    'Basic\nInfo',
    'Training\nRules',
    'Pricing',
    'Preview',
  ];

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final done = i < currentStep;
        final active = i == currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (done || active)
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFFE5E7EB),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: done
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                            : Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: active
                                      ? Colors.white
                                      : Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _labels[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: active
                            ? const Color(0xFF4F46E5)
                            : Colors.grey[400],
                        fontWeight: active
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < 3)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 20),
                    color: i < currentStep
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

// ── Step 1: Basic Info ────────────────────────────────────────────────────────

class _Step1BasicInfo extends StatelessWidget {
  final TextEditingController nameCtrl;
  final String? packageType;
  final String? linkedService;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onServiceChanged;

  const _Step1BasicInfo({
    super.key,
    required this.nameCtrl,
    required this.packageType,
    required this.linkedService,
    required this.onTypeChanged,
    required this.onServiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('Package Name'),
        const SizedBox(height: 6),
        TextField(
          controller: nameCtrl,
          decoration: _dec('e.g., Weight Loss Package'),
        ),
        const SizedBox(height: 16),
        const _Label('Package Type'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: packageType,
          hint: const Text('Select type'),
          decoration: _dec(null),
          items: const [
            DropdownMenuItem(value: 'weight_loss', child: Text('Weight Loss')),
            DropdownMenuItem(value: 'strength', child: Text('Strength Building')),
            DropdownMenuItem(value: 'cardio', child: Text('Cardio')),
            DropdownMenuItem(value: 'general', child: Text('General Fitness')),
          ],
          onChanged: onTypeChanged,
        ),
        const SizedBox(height: 16),
        const _Label('Linked PT Service'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: linkedService,
          hint: const Text('Select service'),
          decoration: _dec(null),
          items: const [
            DropdownMenuItem(value: '1', child: Text('Personal Training')),
            DropdownMenuItem(value: '2', child: Text('Strength Training')),
            DropdownMenuItem(value: '3', child: Text('Weight Loss Program')),
          ],
          onChanged: onServiceChanged,
        ),
      ],
    );
  }
}

// ── Step 2: Training Rules ────────────────────────────────────────────────────

class _Step2TrainingRules extends StatelessWidget {
  final TextEditingController totalSessionsCtrl;
  final TextEditingController minDaysCtrl;
  final TextEditingController maxDaysCtrl;
  final TextEditingController validityCtrl;

  const _Step2TrainingRules({
    super.key,
    required this.totalSessionsCtrl,
    required this.minDaysCtrl,
    required this.maxDaysCtrl,
    required this.validityCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('Total Sessions'),
        const SizedBox(height: 6),
        TextField(
          controller: totalSessionsCtrl,
          keyboardType: TextInputType.number,
          decoration: _dec('e.g., 16'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Label('Min Days/Week'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: minDaysCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _dec('1'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Label('Max Days/Week'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: maxDaysCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _dec('2'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _Label('Validity (Days)'),
        const SizedBox(height: 6),
        TextField(
          controller: validityCtrl,
          keyboardType: TextInputType.number,
          decoration: _dec('e.g., 112'),
        ),
      ],
    );
  }
}

// ── Step 3: Pricing ───────────────────────────────────────────────────────────

class _Step3Pricing extends StatelessWidget {
  final TextEditingController regularPriceCtrl;
  final TextEditingController salePriceCtrl;

  const _Step3Pricing({
    super.key,
    required this.regularPriceCtrl,
    required this.salePriceCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('Regular Price (\$)'),
        const SizedBox(height: 6),
        TextField(
          controller: regularPriceCtrl,
          keyboardType: TextInputType.number,
          decoration: _dec('e.g., 640'),
        ),
        const SizedBox(height: 16),
        const _Label('Sale Price (\$) - Optional'),
        const SizedBox(height: 6),
        TextField(
          controller: salePriceCtrl,
          keyboardType: TextInputType.number,
          decoration: _dec('e.g., 500'),
        ),
      ],
    );
  }
}

// ── Step 4: Preview ───────────────────────────────────────────────────────────

class _Step4Preview extends StatelessWidget {
  final String name;
  final String sessions;
  final String minDays;
  final String maxDays;
  final String validity;
  final String price;

  const _Step4Preview({
    super.key,
    required this.name,
    required this.sessions,
    required this.minDays,
    required this.maxDays,
    required this.validity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Package Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const Divider(height: 20),
          _Row('Name:', name.isEmpty ? 'N/A' : name),
          _Row('Sessions:', sessions.isEmpty ? 'N/A' : sessions),
          _Row(
            'Frequency:',
            (minDays.isEmpty && maxDays.isEmpty)
                ? '?-? days/week'
                : '$minDays-$maxDays days/week',
          ),
          _Row(
              'Validity:',
              validity.isEmpty ? 'N/A days' : '$validity days'),
          _Row(
            'Price:',
            price.isEmpty ? '\$0' : '\$$price',
            valueColor: const Color(0xFF4F46E5),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Row(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF374151),
      ),
    );
  }
}

InputDecoration _dec(String? hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[200]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[200]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
          const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 14, vertical: 12),
  );
}
