// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/presentation/widgets/business_rules_section_widget.dart
//
// PURPOSE:
//   Renders the "Business Rules" settings section (Admin/Owner only).
//   Contains a collapsible "Subscription Rules" group with 4 toggles
//   matching the 4 fields of GymSettings on the backend.
//
// DATA FLOW:
//   1. AdminSettingsCubit loads rules via GET /api/admin/settings on init.
//   2. User changes a toggle → cubit.updateBusinessRule() → marks dirty.
//   3. "Save Changes" pressed → cubit.saveSettings() → PUT /api/admin/settings.
//
// ROLE-BASED ACCESS:
//   OWNER → toggles are interactive.
//   ADMIN → toggles are disabled with an explanatory tooltip.
//   Role is read from the JWT stored in FlutterSecureStorage.
//
// DESIGN (matches Figma):
//   Orange gear icon header. "Admin Only" orange pill badge.
//   Collapsible "Subscription Rules" group (expand/collapse chevron).
//   Each row: bold label + body subtitle + Switch.
//   Loading state: CircularProgressIndicator.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/utils/jwt_utils.dart';
import '../../../../../l10n/app_localizations.dart';
import '../cubit/admin_settings_cubit.dart';
import '../cubit/admin_settings_state.dart';

class BusinessRulesSectionWidget extends StatefulWidget {
  const BusinessRulesSectionWidget({super.key});

  @override
  State<BusinessRulesSectionWidget> createState() =>
      _BusinessRulesSectionWidgetState();
}

class _BusinessRulesSectionWidgetState
    extends State<BusinessRulesSectionWidget> {
  // ── Local UI state ──────────────────────────────────────────────────────────
  bool _isExpanded = true;        // Subscription Rules group starts expanded
  bool _isRefundExpanded = false; // Refund Policy group starts collapsed
  bool? _isOwner;

  // Text controllers for refund window hour inputs.
  final _planCtrl = TextEditingController();
  final _classCtrl = TextEditingController();
  final _ptPkgCtrl = TextEditingController();
  bool _controllersInitialized = false;

  @override
  void dispose() {
    _planCtrl.dispose();
    _classCtrl.dispose();
    _ptPkgCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _resolveRole();
  }

  /// Reads the admin role from secure storage. The whole section is
  /// OWNER-only — until the role resolves to OWNER, nothing renders here
  /// (no placeholder/spinner), so other roles never see it at all.
  Future<void> _resolveRole() async {
    const storage = FlutterSecureStorage();
    // Role is stored separately under 'admin_role' by AdminTokenStore.
    final role = await storage.read(key: 'admin_role') ?? '';
    if (mounted) setState(() => _isOwner = role == 'OWNER');
  }

  @override
  Widget build(BuildContext context) {
    if (_isOwner != true) return const SizedBox.shrink();

    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final state = context.watch<AdminSettingsCubit>().state;
    final cubit = context.read<AdminSettingsCubit>();
    final l10n = AppLocalizations.of(context)!;

    // Initialise text controllers once the business rules load from backend.
    if (!_controllersInitialized && state.businessRules != null) {
      final rules = state.businessRules!;
      _planCtrl.text = rules.planRefundWindowHours?.toString() ?? '';
      _classCtrl.text = rules.classRefundWindowHours?.toString() ?? '';
      _ptPkgCtrl.text = rules.ptPackageRefundWindowHours?.toString() ?? '';
      _controllersInitialized = true;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          // ── Section header ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Orange gear icon background
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.settings_rounded,
                      color: Colors.orange, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx)!;
                      return Row(
                        children: [
                          Text(l10n.admin_settings_businessTitle,
                              style: tokens.typography.titleMedium),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.orange.withOpacity(0.3)),
                            ),
                            child: Text(l10n.admin_settings_adminOnly,
                                style: tokens.typography.bodySmall.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ],
                      );
                    }),
                    Builder(builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx)!;
                      return Text(l10n.admin_settings_businessSubtitle,
                          style: tokens.typography.bodySmall.copyWith(color: c.muted));
                    }),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: c.border.withOpacity(0.2)),

          // ── Collapsible: Subscription Rules ──────────────────────────────
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.admin_settings_subscriptionRules,
                      style: tokens.typography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  // Animated chevron (points up when expanded, down when collapsed)
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0, // 180° when expanded
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 22, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // ── Toggle rows (only visible when expanded) ──────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? _buildToggles(context, state, cubit, tokens, c)
                : const SizedBox.shrink(),
          ),

          Divider(height: 1, color: c.border.withOpacity(0.2)),

          // ── Collapsible: Refund Policy ────────────────────────────────────
          InkWell(
            onTap: () => setState(() => _isRefundExpanded = !_isRefundExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.assignment_return_outlined,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(l10n.admin_settings_refundPolicy,
                      style: tokens.typography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _isRefundExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 22, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _isRefundExpanded
                ? _buildRefundPolicyFields(context, state, cubit, tokens, c)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildToggles(BuildContext context, AdminSettingsState state,
      AdminSettingsCubit cubit, dynamic tokens, dynamic c) {
    if (state.status == AdminSettingsStatus.loading ||
        state.businessRules == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final rules = state.businessRules!;
    final l10n  = AppLocalizations.of(context)!;

    return Column(
      children: [
        Divider(height: 1, color: c.border.withOpacity(0.15)),
        _ToggleRow(
          label: l10n.admin_settings_allowClassWithoutMembership,
          subtitle: l10n.admin_settings_allowClassWithoutMembershipDesc,
          value: rules.allowClassWithoutMembership,
          isOwner: true,
          onChanged: (v) =>
              cubit.updateBusinessRule(allowClassWithoutMembership: v),
          tokens: tokens,
          c: c,
        ),
        Divider(height: 1, color: c.border.withOpacity(0.15)),
        _ToggleRow(
          label: l10n.admin_settings_requireMembershipForClass,
          subtitle: l10n.admin_settings_requireMembershipForClassDesc,
          value: rules.requireMembershipForClass,
          isOwner: true,
          onChanged: (v) =>
              cubit.updateBusinessRule(requireMembershipForClass: v),
          tokens: tokens,
          c: c,
        ),
        Divider(height: 1, color: c.border.withOpacity(0.15)),
        _ToggleRow(
          label: l10n.admin_settings_allowMembershipWithoutClass,
          subtitle: l10n.admin_settings_allowMembershipWithoutClassDesc,
          value: rules.allowMembershipWithoutClass,
          isOwner: true,
          onChanged: (v) =>
              cubit.updateBusinessRule(allowMembershipWithoutClass: v),
          tokens: tokens,
          c: c,
        ),
        Divider(height: 1, color: c.border.withOpacity(0.15)),
        _ToggleRow(
          label: l10n.admin_settings_allowBothIndependently,
          subtitle: l10n.admin_settings_allowBothIndependentlyDesc,
          value: rules.allowBothIndependently,
          isOwner: true,
          onChanged: (v) =>
              cubit.updateBusinessRule(allowBothIndependently: v),
          tokens: tokens,
          c: c,
        ),
        Divider(height: 1, color: c.border.withOpacity(0.15)),
        _ToggleRow(
          label: l10n.admin_settings_allowPtBookingWithoutMembership,
          subtitle: l10n.admin_settings_allowPtBookingWithoutMembershipDesc,
          value: rules.allowPtBookingWithoutMembership,
          isOwner: true,
          onChanged: (v) =>
              cubit.updateBusinessRule(allowPtBookingWithoutMembership: v),
          tokens: tokens,
          c: c,
        ),
      ],
    );
  }

  Widget _buildRefundPolicyFields(BuildContext context,
      AdminSettingsState state, AdminSettingsCubit cubit,
      dynamic tokens, dynamic c) {
    if (state.status == AdminSettingsStatus.loading ||
        state.businessRules == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.admin_settings_refundPolicyDesc,
              style: tokens.typography.bodySmall.copyWith(color: c.muted)),
          const SizedBox(height: 12),
          _RefundWindowField(
            label: l10n.admin_settings_planRefundWindow,
            hint: l10n.admin_settings_planRefundWindowDesc,
            controller: _planCtrl,
            tokens: tokens,
            c: c,
            onChanged: (v) => cubit.updatePlanRefundWindow(v),
          ),
          const SizedBox(height: 12),
          _RefundWindowField(
            label: l10n.admin_settings_classRefundWindow,
            hint: l10n.admin_settings_classRefundWindowDesc,
            controller: _classCtrl,
            tokens: tokens,
            c: c,
            onChanged: (v) => cubit.updateClassRefundWindow(v),
          ),
          const SizedBox(height: 12),
          _RefundWindowField(
            label: l10n.admin_settings_ptPackageRefundWindow,
            hint: l10n.admin_settings_ptPackageRefundWindowDesc,
            controller: _ptPkgCtrl,
            tokens: tokens,
            c: c,
            onChanged: (v) => cubit.updatePtPackageRefundWindow(v),
          ),
        ],
      ),
    );
  }
}

// ─── Refund window number input field ────────────────────────────────────────

class _RefundWindowField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<int?> onChanged;
  final dynamic tokens;
  final dynamic c;

  const _RefundWindowField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    required this.tokens,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: tokens.typography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: tokens.typography.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: tokens.typography.bodySmall.copyWith(color: c.muted),
            filled: true,
            fillColor: c.background,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: c.border.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: c.border.withOpacity(0.3)),
            ),
          ),
          onChanged: (text) {
            if (text.trim().isEmpty) {
              onChanged(null);
            } else {
              final parsed = int.tryParse(text.trim());
              if (parsed != null && parsed >= 0) onChanged(parsed);
            }
          },
        ),
      ],
    );
  }
}

// ─── Individual toggle row ────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final bool isOwner; // false = ADMIN, disables the toggle
  final ValueChanged<bool> onChanged;
  final dynamic tokens;
  final dynamic c;

  const _ToggleRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.isOwner,
    required this.onChanged,
    required this.tokens,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final toggle = Switch(
      value: value,
      // null onChanged = disabled switch (grey, non-interactive)
      onChanged: isOwner ? onChanged : null,
      activeColor: c.primary,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: tokens.typography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: tokens.typography.bodySmall.copyWith(color: c.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Wrap disabled toggle in Tooltip for ADMIN users
          isOwner
              ? toggle
              : Tooltip(
            message: AppLocalizations.of(context)!.admin_settings_ownerOnly,
            child: toggle,
          ),
        ],
      ),
    );
  }
}
