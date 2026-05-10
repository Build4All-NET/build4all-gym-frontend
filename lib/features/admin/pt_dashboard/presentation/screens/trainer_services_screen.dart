// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/screens/trainer_services_screen.dart
//
// DESIGN: Images 10-11 — Services screen (More tab).
//
// Shows PT services list with category filter tabs.
// "+ New Service" button and FAB open the Create PT Service dialog.
//
// TODO: Wire to real backend PT services endpoints when implemented.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';

class TrainerServicesScreen extends StatefulWidget {
  const TrainerServicesScreen({super.key});

  @override
  State<TrainerServicesScreen> createState() =>
      _TrainerServicesScreenState();
}

class _TrainerServicesScreenState extends State<TrainerServicesScreen> {
  String _activeFilter = 'All';

  // Stub services — replace with real BLoC data.
  final _services = <_ServiceData>[
    const _ServiceData(
      name: 'Personal Training',
      description: 'One-on-one customized workout sessions',
      category: 'General',
      durationMin: 60,
      price: 50,
      isActive: true,
    ),
    const _ServiceData(
      name: 'Strength Training',
      description: 'Focus on building muscle and strength',
      category: 'Specialized',
      durationMin: 45,
      price: 45,
      isActive: true,
    ),
    const _ServiceData(
      name: 'Weight Loss Program',
      description: 'Targeted fat burning and cardio sessions',
      category: 'General',
      durationMin: 60,
      price: 55,
      isActive: true,
    ),
  ];

  List<_ServiceData> get _filtered =>
      _activeFilter == 'All'
          ? _services
          : _services
              .where((s) => s.category == _activeFilter)
              .toList();

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
          'Services',
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
              onPressed: () => _CreateServiceDialog.show(
                context,
                onCreated: (s) => setState(() => _services.add(s)),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Service',
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
      body: Column(
        children: [
          // Category filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'General', 'Specialized', 'Elite']
                    .map((f) => _FilterChip(
                          label: f,
                          selected: _activeFilter == f,
                          onTap: () =>
                              setState(() => _activeFilter = f),
                        ))
                    .toList(),
              ),
            ),
          ),

          // Service list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (_, i) =>
                  _ServiceCard(service: _filtered[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _CreateServiceDialog.show(
          context,
          onCreated: (s) => setState(() => _services.add(s)),
        ),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Service data model (stub) ─────────────────────────────────────────────────

class _ServiceData {
  final String name;
  final String description;
  final String category;
  final int durationMin;
  final double price;
  final bool isActive;

  const _ServiceData({
    required this.name,
    required this.description,
    required this.category,
    required this.durationMin,
    required this.price,
    required this.isActive,
  });
}

// ── Filter chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF4F46E5)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

// ── Service card ──────────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  final _ServiceData service;
  const _ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon badge
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.sports_gymnastics,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        service.description,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  '${service.durationMin} min',
                  style:
                      TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Text(
                  '\$ ${service.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                const Spacer(),
                if (service.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Active',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF059669),
                        )),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit Service'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4F46E5),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Create Service dialog ─────────────────────────────────────────────────────

class _CreateServiceDialog extends StatefulWidget {
  final ValueChanged<_ServiceData> onCreated;

  const _CreateServiceDialog({required this.onCreated});

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<_ServiceData> onCreated,
  }) {
    return showDialog(
      context: context,
      builder: (_) => _CreateServiceDialog(onCreated: onCreated),
    );
  }

  @override
  State<_CreateServiceDialog> createState() =>
      _CreateServiceDialogState();
}

class _CreateServiceDialogState
    extends State<_CreateServiceDialog> {
  final _nameCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _durationCtrl = TextEditingController(text: '60');
  final _priceCtrl = TextEditingController(text: '50');
  final _descriptionCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _durationCtrl.dispose();
    _priceCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty) return;

    widget.onCreated(_ServiceData(
      name: _nameCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      category: _categoryCtrl.text.trim().isEmpty
          ? 'General'
          : _categoryCtrl.text.trim(),
      durationMin:
          int.tryParse(_durationCtrl.text.trim()) ?? 60,
      price: double.tryParse(_priceCtrl.text.trim()) ?? 50,
      isActive: true,
    ));

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Service created successfully.'),
        backgroundColor: Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create PT Service',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close,
                      color: Color(0xFF9CA3AF)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const _SLabel('Service Name'),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              decoration: _sdec('e.g., Personal Training'),
            ),

            const SizedBox(height: 16),

            const _SLabel('Category'),
            const SizedBox(height: 6),
            TextField(
              controller: _categoryCtrl,
              decoration: _sdec('e.g., General, Specialized, Elite'),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SLabel('Duration (min)'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _durationCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _sdec('60'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SLabel('Price (\$)'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _priceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _sdec('50'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const _SLabel('Description'),
            const SizedBox(height: 6),
            TextField(
              controller: _descriptionCtrl,
              maxLines: 3,
              decoration: _sdec('Describe the service...'),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_circle_outline,
                        size: 18),
                    label: const Text('Create Service'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
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
}

class _SLabel extends StatelessWidget {
  final String text;
  const _SLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151)));
  }
}

InputDecoration _sdec(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
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
