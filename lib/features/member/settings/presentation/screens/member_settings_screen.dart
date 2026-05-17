// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/presentation/screens/member_settings_screen.dart
//
// PURPOSE:
//   Member Settings screen.
//
//   Lets the connected member configure:
//     • Appearance / theme
//     • Language
//     • Account security options
//     • Danger zone actions
//
// SAME STRUCTURE AS ADMIN:
//   AdminSettingsScreen provides AppearanceSettingsCubit inside the screen,
//   listens to theme changes, keeps the Scaffold in a private body widget,
//   and uses a sticky Save Changes button. Member follows the same pattern.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/localization/locale_cubit.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';

import 'package:build4allgym/common/settings/cubits/appearance_settings_cubit.dart';
import 'package:build4allgym/common/settings/widgets/appearance_section_widget.dart';
import 'package:build4allgym/common/settings/widgets/language_section_widget.dart';
import 'package:build4allgym/common/settings/widgets/settings_version_footer.dart';

import 'package:build4allgym/features/admin/settings/presentation/widgets/danger_zone_section_widget.dart';

import '../cubit/member_settings_cubit.dart';
import '../cubit/member_settings_state.dart';
import '../widgets/member_account_security_widget.dart';

class MemberSettingsScreen extends StatelessWidget {
  const MemberSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final memberCubit = context.read<MemberSettingsCubit>();

    return BlocProvider<AppearanceSettingsCubit>(
      create: (ctx) => AppearanceSettingsCubit(
        initial: ctx.read<ThemeCubit>().state.selectedThemeMode,
      ),
      child: BlocListener<AppearanceSettingsCubit, ThemeMode>(
        listener: (context, themeMode) {
          memberCubit.setThemeMode(themeMode);
          context.read<ThemeCubit>().setThemeMode(themeMode);
        },
        child: const _MemberSettingsBody(),
      ),
    );
  }
}

class _MemberSettingsBody extends StatelessWidget {
  const _MemberSettingsBody();

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;

    final state = context.watch<MemberSettingsCubit>().state;
    final cubit = context.read<MemberSettingsCubit>();

    if (state.status == MemberSettingsStatus.loading) {
      return Scaffold(
        backgroundColor: c.background,
        appBar: _buildAppBar(context, tokens, c, state),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.status == MemberSettingsStatus.error) {
      return Scaffold(
        backgroundColor: c.background,
        appBar: _buildAppBar(context, tokens, c, state),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage ?? 'Unexpected error occurred',
                  textAlign: TextAlign.center,
                  style: tokens.typography.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: cubit.reload,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: c.background,
      appBar: _buildAppBar(context, tokens, c, state),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  const AppearanceSectionWidget(),

                  LanguageSectionWidget(
                    selectedLocale: state.pendingLocale,
                    onLocaleChanged: (locale) {
                      cubit.setPendingLocale(locale);
                      context.read<LocaleCubit>().setLocale(locale);
                    },
                  ),
                  const MemberAccountSecurityWidget(),

                  const DangerZoneSectionWidget(),

                  const SettingsVersionFooter(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          _SaveChangesButton(
            isDirty: state.isDirty,
            isSaving: false,
            onSave: () => _onSave(context, cubit),
            tokens: tokens,
            c: c,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context,
      dynamic tokens,
      dynamic c,
      MemberSettingsState state,
      ) {
    return AppBar(
      backgroundColor: c.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: c.label),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Settings',
        style: tokens.typography.titleMedium,
      ),
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
    );
  }

  Future<void> _onSave(
      BuildContext context,
      MemberSettingsCubit cubit,
      ) async {
    final success = await cubit.saveSettings();
    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cubit.state.errorMessage ?? 'Failed to save settings',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

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
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.save_rounded, size: 20),
            label: Text(
              isSaving ? 'Saving...' : 'Save Changes',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
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