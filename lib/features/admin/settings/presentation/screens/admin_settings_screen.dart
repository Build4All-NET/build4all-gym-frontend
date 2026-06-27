// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/presentation/screens/admin_settings_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/localization/locale_cubit.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../../common/settings/widgets/language_section_widget.dart';
import '../../../../../../common/settings/widgets/settings_version_footer.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../cubit/admin_settings_cubit.dart';
import '../cubit/admin_settings_state.dart';
import '../widgets/account_security_section_widget.dart';
import '../widgets/business_rules_section_widget.dart';
import '../widgets/danger_zone_section_widget.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => const _AdminSettingsBody();
}

// ─── Body extracted so build() above stays clean ──────────────────────────────

class _AdminSettingsBody extends StatelessWidget {
  const _AdminSettingsBody();

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final state = context.watch<AdminSettingsCubit>().state;
    final cubit = context.read<AdminSettingsCubit>();
    final profile = context.watch<AdminProfileCubit>().state;
    return Scaffold(
      backgroundColor: c.background,

      drawer: AdminNavigationDrawer(
        gymName: profile.gymName,
        branchName: profile.branchName,
        adminName: profile.adminName,
        adminEmail: profile.adminEmail,
        avatarUrl: profile.avatarUrl,
        initialActiveId: 'settings',
      ),


      // ── AppBar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu, color: c.label),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(AppLocalizations.of(context)!.navSettings, style: tokens.typography.titleMedium),
        actions: [
          if (state.isDirty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                label: Text(AppLocalizations.of(context)!.admin_settings_unsaved,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),

      // ── Body (scrollable) ─────────────────────────────────────────────────
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ── Static search bar ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.admin_settings_searchHint,
                        prefixIcon: Icon(Icons.search, color: c.muted),
                        filled: true,
                        fillColor: c.surface,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(tokens.search.radius),
                          borderSide:
                          BorderSide(color: c.border.withOpacity(0.2)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(tokens.search.radius),
                          borderSide:
                          BorderSide(color: c.border.withOpacity(0.2)),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── 1. Language & Region ──────────────────────────────────
                  LanguageSectionWidget(
                    selectedLocale: state.pendingLocale,
                    onLocaleChanged: (locale) =>
                        cubit.setPendingLocale(locale),
                  ),

                  // ── 3. Account & Security ─────────────────────────────────
                  const AccountSecuritySectionWidget(),

                  // ── 4. Business Rules ─────────────────────────────────────
                  const BusinessRulesSectionWidget(),

                  // ── 5. Legal & Policies (stub) ────────────────────────────
                  _LegalPoliciesStub(tokens: tokens, c: c),

                  // ── 6. Danger Zone ────────────────────────────────────────
                  const DangerZoneSectionWidget(),

                  // ── Version footer ────────────────────────────────────────
                  const SettingsVersionFooter(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ── Sticky Save Changes button ────────────────────────────────────
          _SaveChangesButton(
            isDirty: state.isDirty,
            isSaving: state.status == AdminSettingsStatus.saving,
            onSave: () => _onSave(context, cubit),
            tokens: tokens,
            c: c,
          ),
        ],
      ),
    );
  }

  Future<void> _onSave(
      BuildContext context, AdminSettingsCubit cubit) async {
    final state = cubit.state;
    final l10n = AppLocalizations.of(context)!;

    final success = await cubit.saveSettings();
    if (!context.mounted) return;

    if (success) {
      await context.read<LocaleCubit>().setLocale(state.pendingLocale);
      if (!context.mounted) return;
      context.read<ThemeCubit>().setThemeMode(state.selectedThemeMode);
      // context.read<ThemeCubit>().setThemeMode(state.selectedThemeMode);
      // ↑ Uncomment when GA-478 adds setThemeMode() to ThemeCubit.

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.admin_settings_saveSuccess),
            backgroundColor: Colors.green),
      );
    } else {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text(cubit.state.errorMessage ?? l10n.admin_settings_saveFailed),
            backgroundColor: Colors.red),
      );
    }
  }
}

// ─── Sticky Save Changes button ───────────────────────────────────────────────

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
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2),
          )
              : const Icon(Icons.save_rounded, size: 20),
          label: Text(isSaving ? AppLocalizations.of(context)!.admin_settings_saving : AppLocalizations.of(context)!.admin_settings_saveChanges,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDirty ? Colors.blue : Colors.grey.shade300,
            foregroundColor:
            isDirty ? Colors.white : Colors.grey.shade600,
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

// ─── Legal & Policies stub ───────────────────────────────────────────────────

class _LegalPoliciesStub extends StatelessWidget {
  final dynamic tokens;
  final dynamic c;

  const _LegalPoliciesStub({required this.tokens, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.muted.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
            Icon(Icons.description_outlined, color: c.muted, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.admin_settings_legalTitle,
                    style: tokens.typography.titleMedium),
                Text(AppLocalizations.of(context)!.admin_settings_legalSubtitle,
                    style: tokens.typography.bodySmall
                        .copyWith(color: c.muted)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: c.muted),
        ],
      ),
    );
  }
}