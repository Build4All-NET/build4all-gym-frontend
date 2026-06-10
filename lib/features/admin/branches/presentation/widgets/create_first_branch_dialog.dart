import 'package:build4allgym/features/admin/branches/domain/usecase/delete_branch_usecase.dart';
import 'package:build4allgym/features/admin/branches/domain/usecase/update_branch_usecase.dart';
import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/branch_repository_impl.dart';
import '../../domain/usecase/create_branch_usecase.dart';
import '../../domain/usecase/get_branch_detail_usecase.dart';
import '../../domain/usecase/get_branches_usecase.dart';
import '../bloc/branches_bloc.dart';
import '../bloc/branches_event.dart';
import '../bloc/branches_state.dart';
import '../../../AppBar/presentation/branch_cubit.dart';

/// Shows a non-dismissible dialog so the admin must create the first branch
/// before using the app. On success, reloads [BranchCubit] so the AppBar
/// dropdown reflects the new branch immediately.
Future<void> showCreateFirstBranchDialog(BuildContext context) {
  final branchCubit = context.read<BranchCubit>();
  final repo = BranchRepositoryImpl();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider(
      create: (_) => BranchesBloc(
        getBranchesUseCase: GetBranchesUseCase(repo),
        getBranchDetailUseCase: GetBranchDetailUseCase(repo),
        createBranchUseCase: CreateBranchUseCase(repo), 
        updateBranchUseCase: UpdateBranchUseCase(repo), 
        deleteBranchUseCase: DeleteBranchUseCase(repo),
      ),
      child: _CreateFirstBranchDialog(
        onBranchCreated: () => branchCubit.reload(),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class _CreateFirstBranchDialog extends StatefulWidget {
  const _CreateFirstBranchDialog({required this.onBranchCreated});
  final VoidCallback onBranchCreated;

  @override
  State<_CreateFirstBranchDialog> createState() =>
      _CreateFirstBranchDialogState();
}

class _CreateFirstBranchDialogState extends State<_CreateFirstBranchDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl    = TextEditingController();
  final _cityCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();

  String? _openingTime;
  String? _closingTime;
  bool    _isOpen24Hours = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchesBloc, BranchesState>(
      listenWhen: (_, s) => s is BranchCreated || s is BranchCreateError,
      listener: (ctx, state) {
        if (state is BranchCreated) {
          Navigator.of(ctx).pop();
          widget.onBranchCreated();
          AppToast.success(context, 'Branch created successfully!');
        } else if (state is BranchCreateError) {
          AppToast.error(ctx, state.message);
        }
      },
      child: Dialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Basic Information'),
                      const SizedBox(height: 10),
                      _field(
                        ctrl: _nameCtrl,
                        label: 'Branch Name',
                        hint: 'e.g. Main Gym – Downtown',
                        icon: Icons.store_mall_directory_outlined,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Branch name is required'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _field(
                        ctrl: _cityCtrl,
                        label: 'City',
                        hint: 'e.g. Cairo',
                        icon: Icons.location_city_outlined,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'City is required'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _sectionLabel('Contact'),
                      const SizedBox(height: 10),
                      _field(
                        ctrl: _phoneCtrl,
                        label: 'Phone',
                        hint: '+20 100 000 0000',
                        icon: Icons.phone_outlined,
                        keyboard: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Phone is required'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _field(
                        ctrl: _emailCtrl,
                        label: 'Email',
                        hint: 'branch@yourgym.com',
                        icon: Icons.email_outlined,
                        keyboard: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(v.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _field(
                        ctrl: _addressCtrl,
                        label: 'Address',
                        hint: '123 Main St, Downtown',
                        icon: Icons.place_outlined,
                        maxLines: 2,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Address is required'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _sectionLabel('Operating Hours'),
                      const SizedBox(height: 10),
                      _Open24HoursTile(
                        value: _isOpen24Hours,
                        onChanged: (v) => setState(() {
                          _isOpen24Hours = v;
                          if (v) {
                            _openingTime = null;
                            _closingTime = null;
                          }
                        }),
                      ),
                      if (!_isOpen24Hours) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _TimeTile(
                                label: 'Opening',
                                value: _openingTime,
                                onPicked: (t) =>
                                    setState(() => _openingTime = t),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TimeTile(
                                label: 'Closing',
                                value: _closingTime,
                                onPicked: (t) =>
                                    setState(() => _closingTime = t),
                              ),
                            ),
                          ],
                        ),
                        if (_openingTime != null &&
                            _closingTime != null &&
                            !_isClosingAfterOpening())
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Closing time must be after opening time',
                              style: TextStyle(
                                  color: Colors.red[600], fontSize: 12),
                            ),
                          ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            _Footer(onSubmit: _submit),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
            letterSpacing: 0.5),
      );

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboard,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
        hintStyle:
            const TextStyle(color: Color(0xFFD1D5DB), fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_isOpen24Hours) {
      if (_openingTime == null) {
        _snack('Please select an opening time');
        return;
      }
      if (_closingTime == null) {
        _snack('Please select a closing time');
        return;
      }
      if (!_isClosingAfterOpening()) {
        _snack('Closing time must be after opening time');
        return;
      }
    }

    context.read<BranchesBloc>().add(
          SubmitCreateBranch(
            CreateBranchParams(
              name:          _nameCtrl.text.trim(),
              city:          _cityCtrl.text.trim(),
              phone:         _phoneCtrl.text.trim(),
              email:         _emailCtrl.text.trim(),
              address:       _addressCtrl.text.trim(),
              openingTime:   _isOpen24Hours ? null : _openingTime,
              closingTime:   _isOpen24Hours ? null : _closingTime,
              isOpen24Hours: _isOpen24Hours,
              status:        'ACTIVE',
            ),
          ),
        );
  }

  void _snack(String msg) {
    AppToast.error(context, msg);
  }

  bool _isClosingAfterOpening() {
    if (_openingTime == null || _closingTime == null) return true;
    int toMins(String t) {
      final p = t.split(':');
      return int.parse(p[0]) * 60 + int.parse(p[1]);
    }
    return toMins(_closingTime!) > toMins(_openingTime!);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.store_mall_directory_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Set Up Your First Branch',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create your main gym location to start managing\nmembers, plans, check-ins, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer({required this.onSubmit});
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BlocBuilder<BranchesBloc, BranchesState>(
        builder: (context, state) {
          final isLoading = state is BranchCreating;
          return SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                disabledBackgroundColor:
                    const Color(0xFF93C5FD),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.2),
                    )
                  : const Text(
                      'Create Branch',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _Open24HoursTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Open24HoursTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
          border: Border.all(
            color: value
                ? const Color(0xFF93C5FD)
                : const Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              size: 18,
              color: value
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Open 24 Hours',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: value
                          ? const Color(0xFF1D4ED8)
                          : const Color(0xFF374151),
                    ),
                  ),
                  if (value)
                    const Text(
                      'Branch is always open',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF2563EB),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.label,
    required this.value,
    required this.onPicked,
  });

  final String label;
  final String? value;
  final ValueChanged<String> onPicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          final h = picked.hour.toString().padLeft(2, '0');
          final m = picked.minute.toString().padLeft(2, '0');
          onPicked('$h:$m');
        }
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: value != null
              ? const Color(0xFFEFF6FF)
              : const Color(0xFFF9FAFB),
          border: Border.all(
            color: value != null
                ? const Color(0xFF93C5FD)
                : const Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 18,
              color: value != null
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: value != null
                        ? const Color(0xFF1D4ED8)
                        : const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? 'Tap to set',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: value != null
                        ? const Color(0xFF1E3A8A)
                        : const Color(0xFFD1D5DB),
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
