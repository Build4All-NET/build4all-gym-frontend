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
  bool _isExpanded = true; // Subscription Rules group starts expanded (matches Figma)
  bool _isOwner = false;   // true = OWNER role, false = ADMIN (toggles disabled)

  @override
  void initState() {
    super.initState();
    _resolveRole();
  }

  /// Reads the admin role from secure storage.
  /// OWNER can edit toggles; ADMIN sees them as disabled.
  Future<void> _resolveRole() async {
    const storage = FlutterSecureStorage();
    // Role is stored separately under 'admin_role' by AdminTokenStore.
    final role = await storage.read(key: 'admin_role') ?? '';
    if (mounted) setState(() => _isOwner = role == 'OWNER');
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final state = context.watch<AdminSettingsCubit>().state;
    final cubit = context.read<AdminSettingsCubit>();

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
          isOwner: _isOwner,
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
          isOwner: _isOwner,
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
          isOwner: _isOwner,
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
          isOwner: _isOwner,
          onChanged: (v) =>
              cubit.updateBusinessRule(allowBothIndependently: v),
          tokens: tokens,
          c: c,
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
