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
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

/// Shows a non-dismissible dialog so the admin must create the first branch
/// before using the app. On success, reloads [BranchCubit] so the AppBar
/// dropdown reflects the new branch immediately.
///
/// [initialName] / [initialEmail] / [initialCity] pre-fill the form with data
/// we already know about the gym/admin (e.g. the gym name and admin email) so
/// the owner doesn't retype information the app already has.
Future<void> showCreateFirstBranchDialog(
  BuildContext context, {
  String? initialName,
  String? initialEmail,
  String? initialCity,
}) {
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
        initialName: initialName,
        initialEmail: initialEmail,
        initialCity: initialCity,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class _CreateFirstBranchDialog extends StatefulWidget {
  const _CreateFirstBranchDialog({
    required this.onBranchCreated,
    this.initialName,
    this.initialEmail,
    this.initialCity,
  });
  final VoidCallback onBranchCreated;
  final String? initialName;
  final String? initialEmail;
  final String? initialCity;

  @override
  State<_CreateFirstBranchDialog> createState() =>
      _CreateFirstBranchDialogState();
}

class _CreateFirstBranchDialogState extends State<_CreateFirstBranchDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _cityCtrl;
  final _phoneCtrl = TextEditingController();
  late final TextEditingController _emailCtrl;
  final _addressCtrl = TextEditingController();

  String? _openingTime;
  String? _closingTime;
  bool _isOpen24Hours = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with data we already have so the owner doesn't retype it.
    _nameCtrl = TextEditingController(text: widget.initialName ?? '');
    _cityCtrl = TextEditingController(text: widget.initialCity ?? '');
    _emailCtrl = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    // Keyboard-aware: reserve room for the keyboard via insetPadding so the
    // Dialog shrinks and the form scrolls above it (no overflow).
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<BranchesBloc, BranchesState>(
      listenWhen: (_, s) => s is BranchCreated || s is BranchCreateError,
      listener: (ctx, state) {
        if (state is BranchCreated) {
          Navigator.of(ctx).pop();
          widget.onBranchCreated();
          AppToast.success(context, l10n.branchDialog_createdSuccess);
        } else if (state is BranchCreateError) {
          AppToast.error(ctx, state.message);
        }
      },
      child: Dialog(
        insetPadding: EdgeInsets.fromLTRB(16, 24, 16, 24 + keyboard),
        backgroundColor: c.surface,
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
                        _sectionLabel(c, l10n.branchDialog_sectionBasic),
                        const SizedBox(height: 10),
                        _field(
                          c: c,
                          ctrl: _nameCtrl,
                          label: l10n.branchDialog_name,
                          hint: l10n.branchDialog_nameHint,
                          icon: Icons.store_mall_directory_outlined,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? l10n.branchDialog_nameRequired
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _field(
                          c: c,
                          ctrl: _cityCtrl,
                          label: l10n.branchDialog_city,
                          hint: l10n.branchDialog_cityHint,
                          icon: Icons.location_city_outlined,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? l10n.branchDialog_cityRequired
                              : null,
                        ),
                        const SizedBox(height: 20),
                        _sectionLabel(c, l10n.branchDialog_sectionContact),
                        const SizedBox(height: 10),
                        _field(
                          c: c,
                          ctrl: _phoneCtrl,
                          label: l10n.branchDialog_phone,
                          hint: l10n.branchDialog_phoneHint,
                          icon: Icons.phone_outlined,
                          keyboard: TextInputType.phone,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? l10n.branchDialog_phoneRequired
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _field(
                          c: c,
                          ctrl: _emailCtrl,
                          label: l10n.branchDialog_email,
                          hint: l10n.branchDialog_emailHint,
                          icon: Icons.email_outlined,
                          keyboard: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.branchDialog_emailRequired;
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(v.trim())) {
                              return l10n.branchDialog_emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _field(
                          c: c,
                          ctrl: _addressCtrl,
                          label: l10n.branchDialog_address,
                          hint: l10n.branchDialog_addressHint,
                          icon: Icons.place_outlined,
                          maxLines: 2,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? l10n.branchDialog_addressRequired
                              : null,
                        ),
                        const SizedBox(height: 20),
                        _sectionLabel(c, l10n.branchDialog_sectionHours),
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
                                  label: l10n.branchDialog_opening,
                                  value: _openingTime,
                                  onPicked: (t) =>
                                      setState(() => _openingTime = t),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _TimeTile(
                                  label: l10n.branchDialog_closing,
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
                                l10n.branchDialog_closingAfterOpening,
                                style:
                                    TextStyle(color: c.danger, fontSize: 12),
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

  Widget _sectionLabel(dynamic c, String text) => Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: c.muted,
            letterSpacing: 0.5),
      );

  Widget _field({
    required dynamic c,
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
      style: TextStyle(color: c.label, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: c.muted),
        floatingLabelStyle: TextStyle(color: c.primary),
        prefixIcon: Icon(icon, size: 18, color: c.muted),
        hintStyle: TextStyle(color: c.muted.withOpacity(0.6), fontSize: 13),
        filled: true,
        fillColor: c.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.border.withOpacity(0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.border.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.danger, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = AppLocalizations.of(context)!;
    if (!_isOpen24Hours) {
      if (_openingTime == null) {
        _snack(l10n.branchDialog_selectOpening);
        return;
      }
      if (_closingTime == null) {
        _snack(l10n.branchDialog_selectClosing);
        return;
      }
      if (!_isClosingAfterOpening()) {
        _snack(l10n.branchDialog_closingAfterOpening);
        return;
      }
    }

    context.read<BranchesBloc>().add(
          SubmitCreateBranch(
            CreateBranchParams(
              name: _nameCtrl.text.trim(),
              city: _cityCtrl.text.trim(),
              phone: _phoneCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              address: _addressCtrl.text.trim(),
              openingTime: _isOpen24Hours ? null : _openingTime,
              closingTime: _isOpen24Hours ? null : _closingTime,
              isOpen24Hours: _isOpen24Hours,
              status: 'ACTIVE',
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
    final c = context.read<ThemeCubit>().state.tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            c.primary,
            Color.lerp(c.primary, Colors.white, 0.18) ?? c.primary,
          ],
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
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.store_mall_directory_rounded,
              color: c.onPrimary,
              size: 34,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.branchDialog_setupTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: c.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.branchDialog_setupSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: c.onPrimary.withOpacity(0.85),
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
    final c = context.read<ThemeCubit>().state.tokens.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: c.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                backgroundColor: c.primary,
                disabledBackgroundColor: c.primary.withOpacity(0.5),
                foregroundColor: c.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: c.onPrimary, strokeWidth: 2.2),
                    )
                  : Text(
                      AppLocalizations.of(context)!.branchDialog_create,
                      style: const TextStyle(
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
    final c = context.read<ThemeCubit>().state.tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value ? c.primary.withOpacity(0.08) : c.background,
          border: Border.all(
            color: value ? c.primary.withOpacity(0.5) : c.border.withOpacity(0.4),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              size: 18,
              color: value ? c.primary : c.muted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.branchDialog_open24,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: value ? c.primary : c.label,
                    ),
                  ),
                  if (value)
                    Text(
                      l10n.branchDialog_open24Sub,
                      style: TextStyle(fontSize: 11, color: c.muted),
                    ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: c.primary,
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
    final c = context.read<ThemeCubit>().state.tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final active = value != null;
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: active ? c.primary.withOpacity(0.08) : c.background,
          border: Border.all(
            color: active ? c.primary.withOpacity(0.5) : c.border.withOpacity(0.4),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 18,
              color: active ? c.primary : c.muted,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: active ? c.primary : c.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value ?? l10n.branchDialog_tapToSet,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? c.label : c.muted.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
