// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/screens/trainer_services_screen.dart
//
// Services are tenant-wide, not trainer-specific, so no admin/trainer split needed.
// Both roles see the same services list.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../data/models/pt_service_model.dart';
import '../../data/services/pt_service_service.dart';
import '../bloc/pt_service_bloc.dart';

class TrainerServicesScreen extends StatefulWidget {
  final int tenantId;
  const TrainerServicesScreen({super.key, required this.tenantId});

  @override
  State<TrainerServicesScreen> createState() => _TrainerServicesScreenState();
}

class _TrainerServicesScreenState extends State<TrainerServicesScreen> {
  String _activeFilter = 'All';
  late final PtServiceBloc _bloc;
  List<PtServiceModel> _cachedServices = [];

  @override
  void initState() {
    super.initState();
    _bloc = PtServiceBloc(PtServiceService());
    _bloc.add(LoadServices(widget.tenantId));
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
              onPressed: () => _ServiceDialog.show(
                context,
                bloc:     _bloc,
                tenantId: widget.tenantId,
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
                  onTap: () => setState(() => _activeFilter = f),
                ))
                    .toList(),
              ),
            ),
          ),

          Expanded(
            child: BlocConsumer<PtServiceBloc, PtServiceState>(
              bloc: _bloc,
              listener: (ctx, state) {
                if (state is PtServiceLoaded) {
                  setState(() => _cachedServices = state.services);
                }
                if (state is PtServiceMutated) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Service saved.'),
                      backgroundColor: Color(0xFF22C55E),
                    ),
                  );
                  _bloc.add(LoadServices(widget.tenantId));
                }
                if (state is PtServiceError) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (ctx, state) {
                // Spinner only on first load
                if ((state is PtServiceInitial ||
                    state is PtServiceLoading) &&
                    _cachedServices.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PtServiceError && _cachedServices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Color(0xFFEF4444), size: 48),
                        const SizedBox(height: 12),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style:
                          const TextStyle(color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              _bloc.add(LoadServices(widget.tenantId)),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final all = state is PtServiceLoaded
                    ? state.services
                    : _cachedServices;

                final filtered = _activeFilter == 'All'
                    ? all
                    : all
                    .where((s) => (s.description)
                    .toLowerCase()
                    .contains(_activeFilter.toLowerCase()))
                    .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      all.isEmpty
                          ? 'No services yet.'
                          : 'No services in "$_activeFilter".',
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _ServiceCard(
                    service: filtered[i],
                    bloc:    _bloc,
                    tenantId: widget.tenantId,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ServiceDialog.show(
          context,
          bloc:     _bloc,
          tenantId: widget.tenantId,
        ),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  final PtServiceModel service;
  final PtServiceBloc bloc;
  final int tenantId;

  const _ServiceCard({
    super.key,
    required this.service,
    required this.bloc,
    required this.tenantId,
  });

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
                        style:
                        TextStyle(fontSize: 12, color: Colors.grey[500]),
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
                  '${service.durationMinutes} min',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
                onPressed: () => _ServiceDialog.show(
                  context,
                  bloc:           bloc,
                  tenantId:       tenantId,
                  initialService: service,
                ),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit Service'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4F46E5),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Create / Edit Service dialog ──────────────────────────────────────────────

class _ServiceDialog extends StatefulWidget {
  final PtServiceBloc bloc;
  final int tenantId;
  final PtServiceModel? initialService;

  const _ServiceDialog({
    required this.bloc,
    required this.tenantId,
    this.initialService,
  });

  static Future<void> show(
      BuildContext context, {
        required PtServiceBloc bloc,
        required int tenantId,
        PtServiceModel? initialService,
      }) {
    return showDialog(
      context: context,
      builder: (_) => _ServiceDialog(
        bloc:           bloc,
        tenantId:       tenantId,
        initialService: initialService,
      ),
    );
  }

  @override
  State<_ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<_ServiceDialog> {
  final _nameCtrl        = TextEditingController();
  final _categoryCtrl    = TextEditingController();
  final _durationCtrl    = TextEditingController(text: '60');
  final _priceCtrl       = TextEditingController(text: '50');
  final _descriptionCtrl = TextEditingController();

  bool get _isEditing => widget.initialService != null;

  @override
  void initState() {
    super.initState();
    final svc = widget.initialService;
    if (svc != null) {
      _nameCtrl.text        = svc.name;
      _descriptionCtrl.text = svc.description;
      _durationCtrl.text    = '${svc.durationMinutes}';
      _priceCtrl.text       = svc.price.toStringAsFixed(0);
    }
  }

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
    final data = {
      'name':            _nameCtrl.text.trim(),
      'description':     _descriptionCtrl.text.trim(),
      'category':        _categoryCtrl.text.trim(),
      'durationMinutes': int.tryParse(_durationCtrl.text) ?? 60,
      'price':           double.tryParse(_priceCtrl.text) ?? 50,
      'isActive':        true,
    };

    if (_isEditing) {
      widget.bloc.add(UpdateService(id: widget.initialService!.serviceId, data: data));
    } else {
      widget.bloc.add(CreateService(tenantId: widget.tenantId, data: data));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Edit PT Service' : 'Create PT Service',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(_isEditing ? 'Save Changes' : 'Create Service'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
      borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}