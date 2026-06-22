// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/role_permissions/presentation/screens/role_permissions_screen.dart
//
// Owner-only screen: lets the gym owner decide which admin-drawer nav items
// TRAINER and RECEPTION staff can see/open, per gym. Same Scaffold shell and
// dirty/save UX as AdminSettingsScreen. Has two modes: "All Staff" (the
// original role-wide matrix) and "Specific Account" (per-account overrides
// on top of the role-wide default for one picked trainer/reception member).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../navigation/config/admin_drawer_config.dart';
import '../../../navigation/config/nav_label_resolver.dart';
import '../../../navigation/config/navigation_item.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/nav_permission_entity.dart';
import '../../domain/entities/staff_account_entity.dart';
import '../../domain/entities/user_nav_permission_entity.dart';
import '../cubit/role_permissions_cubit.dart';
import '../cubit/role_permissions_state.dart';

class RolePermissionsScreen extends StatelessWidget {
  const RolePermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) => const _RolePermissionsBody();
}

class _RolePermissionsBody extends StatelessWidget {
  const _RolePermissionsBody();

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<AdminProfileCubit>().state;

    // Defensive guard: this screen is never reachable from the nav for
    // trainer/reception (no flags, never in allowedNavItemIds), but a deep
    // link should still show "not authorized" rather than the editor.
    if (!profile.isAdminRole) {
      return Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(backgroundColor: c.surface, elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.roleAccess_notAuthorized,
              textAlign: TextAlign.center,
              style: tokens.typography.bodyMedium.copyWith(color: c.muted),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: c.background,
      drawer: AdminNavigationDrawer(
        gymName: profile.gymName,
        branchName: profile.branchName,
        adminName: profile.adminName,
        adminEmail: profile.adminEmail,
        avatarUrl: profile.avatarUrl,
        initialActiveId: 'staff_access_control',
      ),
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu, color: c.label),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(l10n.roleAccess_title, style: tokens.typography.titleMedium),
      ),
      body: const _RolePermissionsContent(),
    );
  }
}

class _RolePermissionsContent extends StatelessWidget {
  const _RolePermissionsContent();

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<RolePermissionsCubit>().state;
    final cubit = context.read<RolePermissionsCubit>();

    final isInitialLoad = state.status == RolePermissionsStatus.loading &&
        state.permissions.isEmpty &&
        state.staffAccounts.isEmpty;
    if (isInitialLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == RolePermissionsStatus.error &&
        state.mode == RolePermissionsMode.allStaff &&
        state.permissions.isEmpty) {
      return Center(
        child: Text(
          state.errorMessage ?? l10n.roleAccess_saveFailed,
          style: tokens.typography.bodyMedium.copyWith(color: c.danger),
        ),
      );
    }

    final isDirty = state.mode == RolePermissionsMode.allStaff
        ? state.isDirty
        : state.isUserOverridesDirty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: _ModeSegmentedControl(
            mode: state.mode,
            enabled: !isDirty,
            onChanged: cubit.setMode,
          ),
        ),
        if (isDirty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Chip(
                label: Text(l10n.roleAccess_unsaved,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        Expanded(
          child: state.mode == RolePermissionsMode.allStaff
              ? _AllStaffMatrix(state: state, cubit: cubit, c: c, tokens: tokens, l10n: l10n)
              : _SpecificAccountEditor(state: state, cubit: cubit, c: c, tokens: tokens, l10n: l10n),
        ),
        _SaveChangesButton(
          isDirty: isDirty,
          isSaving: state.status == RolePermissionsStatus.saving,
          onSave: () => _onSave(context, cubit, state.mode),
          tokens: tokens,
          c: c,
        ),
      ],
    );
  }

  Future<void> _onSave(BuildContext context, RolePermissionsCubit cubit, RolePermissionsMode mode) async {
    final l10n = AppLocalizations.of(context)!;
    final success = mode == RolePermissionsMode.allStaff
        ? await cubit.save()
        : await cubit.saveUserOverrides();
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? l10n.roleAccess_saveSuccess : l10n.roleAccess_saveFailed),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}

// ─── Mode toggle ("All Staff" | "Specific Account") ───────────────────────────

class _ModeSegmentedControl extends StatelessWidget {
  final RolePermissionsMode mode;
  final bool enabled;
  final ValueChanged<RolePermissionsMode> onChanged;

  const _ModeSegmentedControl({
    required this.mode,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return SegmentedButton<RolePermissionsMode>(
      segments: [
        ButtonSegment(
          value: RolePermissionsMode.allStaff,
          label: Text(l10n.roleAccess_modeAllStaff),
        ),
        ButtonSegment(
          value: RolePermissionsMode.specificAccount,
          label: Text(l10n.roleAccess_modeSpecificAccount),
        ),
      ],
      selected: {mode},
      onSelectionChanged: enabled ? (s) => onChanged(s.first) : null,
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: c.primary.withOpacity(0.12),
        selectedForegroundColor: c.primary,
      ),
    );
  }
}

// ─── "All Staff" mode — original role-wide matrix ─────────────────────────────

class _AllStaffMatrix extends StatelessWidget {
  final RolePermissionsState state;
  final RolePermissionsCubit cubit;
  final dynamic c;
  final dynamic tokens;
  final AppLocalizations l10n;

  const _AllStaffMatrix({
    required this.state,
    required this.cubit,
    required this.c,
    required this.tokens,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final byItemId = {for (final p in state.permissions) p.itemId: p};

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.roleAccess_subtitle,
              style: tokens.typography.bodySmall.copyWith(color: c.muted),
            ),
          ),
          _ColumnHeaderRow(l10n: l10n, c: c, tokens: tokens),
          for (final section in adminDrawerSections)
            ..._buildSection(section, byItemId, cubit, c, tokens),
          const SizedBox(height: 96),
        ],
      ),
    );
  }

  List<Widget> _buildSection(
    DrawerSection section,
    Map<String, NavPermissionEntity> byItemId,
    RolePermissionsCubit cubit,
    dynamic c,
    dynamic tokens,
  ) {
    final rows = section.items.where((item) => item.configurable && byItemId.containsKey(item.id)).toList();
    if (rows.isEmpty) return const [];

    return [
      if (section.labelKey != null) _SectionLabel(labelKey: section.labelKey!),
      for (final item in rows)
        _PermissionRow(
          item: item,
          permission: byItemId[item.id]!,
          onChanged: (isTrainerColumn, value) =>
              cubit.toggle(itemId: item.id, isTrainerColumn: isTrainerColumn, value: value),
          c: c,
          tokens: tokens,
        ),
    ];
  }
}

// ─── "Specific Account" mode — staff picker + tri-state override rows ────────

class _SpecificAccountEditor extends StatelessWidget {
  final RolePermissionsState state;
  final RolePermissionsCubit cubit;
  final dynamic c;
  final dynamic tokens;
  final AppLocalizations l10n;

  const _SpecificAccountEditor({
    required this.state,
    required this.cubit,
    required this.c,
    required this.tokens,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: _StaffPicker(
              accounts: state.staffAccounts,
              selected: state.selectedAccount,
              enabled: !state.isUserOverridesDirty,
              onSelected: cubit.selectAccount,
              c: c,
              tokens: tokens,
              l10n: l10n,
            ),
          ),
          if (state.selectedAccount == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Text(
                state.staffAccounts.isEmpty
                    ? l10n.roleAccess_noStaffAccounts
                    : l10n.roleAccess_selectAccountPrompt,
                style: tokens.typography.bodySmall.copyWith(color: c.muted),
              ),
            )
          else if (state.status == RolePermissionsStatus.loading)
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            _buildOverrideRows(),
            const SizedBox(height: 96),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildOverrideRowsForSection(
    DrawerSection section,
    Map<String, UserNavPermissionEntity> byItemId,
  ) {
    final rows = section.items.where((item) => item.configurable && byItemId.containsKey(item.id)).toList();
    if (rows.isEmpty) return const [];

    return [
      if (section.labelKey != null) _SectionLabel(labelKey: section.labelKey!),
      for (final item in rows)
        _TriStateOverrideRow(
          item: item,
          permission: byItemId[item.id]!,
          onChanged: (value) => cubit.setOverride(itemId: item.id, value: value),
          c: c,
          tokens: tokens,
          l10n: l10n,
        ),
    ];
  }

  Widget _buildOverrideRows() {
    final byItemId = {for (final o in state.userOverrides) o.itemId: o};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final section in adminDrawerSections)
          ..._buildOverrideRowsForSection(section, byItemId),
      ],
    );
  }
}

class _StaffPicker extends StatelessWidget {
  final List<StaffAccountEntity> accounts;
  final StaffAccountEntity? selected;
  final bool enabled;
  final ValueChanged<StaffAccountEntity> onSelected;
  final dynamic c;
  final dynamic tokens;
  final AppLocalizations l10n;

  const _StaffPicker({
    required this.accounts,
    required this.selected,
    required this.enabled,
    required this.onSelected,
    required this.c,
    required this.tokens,
    required this.l10n,
  });

  String _roleLabel(StaffAccountEntity account) {
    final roles = account.gymRoles.map((r) {
      switch (r) {
        case 'TRAINER':
          return l10n.roleAccess_trainerColumn;
        case 'RECEPTION':
          return l10n.roleAccess_receptionColumn;
        default:
          return r;
      }
    }).join(', ');
    return '${account.fullName} ($roles)';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selected?.userId,
      decoration: InputDecoration(
        labelText: l10n.roleAccess_pickStaffMember,
        filled: true,
        fillColor: c.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: accounts
          .map((a) => DropdownMenuItem<int>(value: a.userId, child: Text(_roleLabel(a))))
          .toList(),
      onChanged: !enabled || accounts.isEmpty
          ? null
          : (userId) {
              if (userId == null) return;
              final account = accounts.firstWhere((a) => a.userId == userId);
              onSelected(account);
            },
    );
  }
}

class _TriStateOverrideRow extends StatelessWidget {
  final NavigationItem item;
  final UserNavPermissionEntity permission;
  final ValueChanged<bool?> onChanged;
  final dynamic c;
  final dynamic tokens;
  final AppLocalizations l10n;

  const _TriStateOverrideRow({
    required this.item,
    required this.permission,
    required this.onChanged,
    required this.c,
    required this.tokens,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = resolveNavLabel(l10n, item.labelKey);
    final defaultLabel = permission.roleDefaultAllowed ? l10n.roleAccess_defaultOn : l10n.roleAccess_defaultOff;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.iconData, size: 20, color: c.muted),
              const SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: label, style: tokens.typography.bodyMedium),
                      TextSpan(
                        text: '  $defaultLabel',
                        style: tokens.typography.bodySmall.copyWith(color: c.muted),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SegmentedButton<bool?>(
            segments: [
              ButtonSegment(value: null, label: Text(l10n.roleAccess_useDefault)),
              ButtonSegment(value: true, label: Text(l10n.roleAccess_alwaysAllow)),
              ButtonSegment(value: false, label: Text(l10n.roleAccess_alwaysDeny)),
            ],
            selected: {permission.override},
            onSelectionChanged: (s) => onChanged(s.first),
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: c.primary.withOpacity(0.12),
              selectedForegroundColor: c.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Column headers ("Trainer" | "Reception") ─────────────────────────────────

class _ColumnHeaderRow extends StatelessWidget {
  final AppLocalizations l10n;
  final dynamic c;
  final dynamic tokens;

  const _ColumnHeaderRow({required this.l10n, required this.c, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 16, 4),
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          _HeaderCell(text: l10n.roleAccess_trainerColumn, c: c, tokens: tokens),
          _HeaderCell(text: l10n.roleAccess_receptionColumn, c: c, tokens: tokens),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final dynamic c;
  final dynamic tokens;

  const _HeaderCell({required this.text, required this.c, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: tokens.typography.bodySmall.copyWith(
          color: c.muted,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Section label ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String labelKey;
  const _SectionLabel({required this.labelKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    final label = switch (labelKey) {
      'sectionOverview' => l10n.sectionOverview,
      'sectionMembers' => l10n.sectionMembers,
      'sectionFrontDesk' => l10n.sectionFrontDesk,
      'sectionTrainingClasses' => l10n.sectionTrainingClasses,
      'sectionFinance' => l10n.sectionFinance,
      'sectionSetup' => l10n.sectionSetup,
      'sectionTools' => l10n.sectionTools,
      _ => labelKey,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface.withOpacity(isDark ? 0.38 : 0.40),
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

// ─── One row: icon + label + Trainer/Reception checkboxes ────────────────────

class _PermissionRow extends StatelessWidget {
  final NavigationItem item;
  final NavPermissionEntity permission;
  final void Function(bool isTrainerColumn, bool value) onChanged;
  final dynamic c;
  final dynamic tokens;

  const _PermissionRow({
    required this.item,
    required this.permission,
    required this.onChanged,
    required this.c,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = resolveNavLabel(l10n, item.labelKey);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Row(
        children: [
          Icon(item.iconData, size: 20, color: c.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: tokens.typography.bodyMedium),
          ),
          SizedBox(
            width: 72,
            child: Checkbox(
              value: permission.trainerAllowed,
              onChanged: (v) => onChanged(true, v ?? false),
            ),
          ),
          SizedBox(
            width: 72,
            child: Checkbox(
              value: permission.receptionAllowed,
              onChanged: (v) => onChanged(false, v ?? false),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sticky Save Changes button (mirrors admin_settings_screen.dart) ────────

class _SaveChangesButton extends StatelessWidget {
  final bool isDirty;
  final bool isSaving;
  final VoidCallback onSave;
  final dynamic tokens;
  final dynamic c;

  const _SaveChangesButton({
    required this.isDirty,
    required this.isSaving,
    required this.onSave,
    required this.tokens,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Container(
        color: c.background,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: (isDirty && !isSaving) ? onSave : null,
            icon: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded, size: 20),
            label: Text(
              isSaving ? l10n.roleAccess_saving : l10n.roleAccess_saveChanges,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDirty ? Colors.blue : Colors.grey.shade300,
              foregroundColor: isDirty ? Colors.white : Colors.grey.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tokens.button.radius),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
