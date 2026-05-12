// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/presentation/screens/member_settings_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/localization/locale_cubit.dart';
import '../../../../../core/theme/theme_cubit.dart';

import '../../../../../../common/settings/widgets/appearance_section_widget.dart';
import '../../../../../../common/settings/widgets/language_section_widget.dart';
import '../../../../../../common/settings/widgets/settings_version_footer.dart';

import '../../../../../features/admin/settings/presentation/widgets/danger_zone_section_widget.dart';

import '../cubit/member_settings_cubit.dart';
import '../widgets/member_account_security_widget.dart';

class MemberSettingsScreen extends StatelessWidget {
  const MemberSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;

    final state = context.watch<MemberSettingsCubit>().state;
    final cubit = context.read<MemberSettingsCubit>();

    return Scaffold(
      backgroundColor: c.background,

      // ── App Bar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: c.label),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Settings', style: tokens.typography.titleMedium),

        actions: [
          if (state.isDirty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                label: const Text(
                  'Unsaved',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),

      // ── Body ───────────────────────────────────────────────────────────────
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ── 1. Appearance (FIXED ❗ no params) ───────────────────────
                  const AppearanceSectionWidget(),

                  // ── 2. Language & Region ────────────────────────────────────
                  LanguageSectionWidget(
                    selectedLocale: state.pendingLocale,
                    onLocaleChanged: (locale) =>
                        cubit.setPendingLocale(locale),
                  ),

                  // ── 3. Account & Security (member version) ──────────────────
                  const MemberAccountSecurityWidget(),

                  // ── 4. Danger Zone ──────────────────────────────────────────
                  const DangerZoneSectionWidget(),

                  // ── 5. Footer ───────────────────────────────────────────────
                  const SettingsVersionFooter(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ── Sticky Save Button ───────────────────────────────────────────────
          Container(
            color: c.background,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: (state.isDirty &&
                    state.status != MemberSettingsStatus.saving)
                    ? () => _onSave(context, cubit, state)
                    : null,

                icon: state.status == MemberSettingsStatus.saving
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.save_rounded, size: 20),

                label: Text(
                  state.status == MemberSettingsStatus.saving
                      ? 'Saving...'
                      : 'Save Changes',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  state.isDirty ? Colors.blue : Colors.grey.shade300,
                  foregroundColor:
                  state.isDirty ? Colors.white : Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(tokens.button.radius),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Save logic ─────────────────────────────────────────────────────────────
  Future<void> _onSave(
      BuildContext context,
      MemberSettingsCubit cubit,
      MemberSettingsState state,
      ) async {
    final success = await cubit.saveSettings();
    if (!context.mounted) return;

    if (success) {
      await context.read<LocaleCubit>().setLocale(state.pendingLocale);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cubit.state.errorMessage ?? 'Save failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}