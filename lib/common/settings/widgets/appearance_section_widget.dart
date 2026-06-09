// ─────────────────────────────────────────────────────────────────────────────
// lib/common/settings/widgets/appearance_section_widget.dart
//
// CHANGE FROM PREVIOUS VERSION:
//   Removed: selectedMode parameter, onModeChanged callback (dumb-widget API).
//   Added:   context.watch<AppearanceSettingsCubit>() for state.
//            context.read<AppearanceSettingsCubit>().setThemeMode() for events.
//
// REQUIREMENT:
//   AppearanceSettingsCubit must be provided above this widget in the tree.
//   Both AdminSettingsScreen and MemberSettingsScreen do this — see those files.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../l10n/app_localizations.dart';
import '../cubits/appearance_settings_cubit.dart';

class AppearanceSectionWidget extends StatelessWidget {
  const AppearanceSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Connect to the two cubits this widget needs ───────────────────────────
    //
    // ThemeCubit   → design tokens only (colors, typography, radii).
    //                Already provided at app root; no extra BlocProvider needed.
    //
    // AppearanceSettingsCubit → which card is currently selected + tap handler.
    //                           Provided by the parent settings screen.
    //
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final selectedMode = context.watch<AppearanceSettingsCubit>().state;
    final c = tokens.colors;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.wb_sunny_rounded,
                    color: Colors.blue, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.settings_appearanceTitle, style: tokens.typography.titleMedium),
                  Text(AppLocalizations.of(context)!.settings_appearanceSubtitle,
                      style: tokens.typography.bodySmall
                          .copyWith(color: c.muted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Mode selector cards ───────────────────────────────────────────
          // Each card reads selectedMode from the cubit and writes back to it
          // via context.read (inside onTap — no rebuild needed for the read).
          _ModeCard(
            icon: Icons.wb_sunny_rounded,
            iconColor: Colors.blue,
            label: AppLocalizations.of(context)!.settings_lightMode,
            subtitle: AppLocalizations.of(context)!.settings_lightModeSubtitle,
            mode: ThemeMode.light,
            selected: selectedMode == ThemeMode.light,
            tokens: tokens,
          ),
          const SizedBox(height: 8),
          _ModeCard(
            icon: Icons.nightlight_round,
            iconColor: Colors.blueGrey,
            label: AppLocalizations.of(context)!.settings_darkMode,
            subtitle: AppLocalizations.of(context)!.settings_darkModeSubtitle,
            mode: ThemeMode.dark,
            selected: selectedMode == ThemeMode.dark,
            tokens: tokens,
          ),
          const SizedBox(height: 8),
          _ModeCard(
            icon: Icons.monitor_rounded,
            iconColor: Colors.grey,
            label: AppLocalizations.of(context)!.settings_systemDefault,
            subtitle: AppLocalizations.of(context)!.settings_systemDefaultSubtitle,
            mode: ThemeMode.system,
            selected: selectedMode == ThemeMode.system,
            tokens: tokens,
          ),
        ],
      ),
    );
  }
}

// ─── Private card widget ──────────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final ThemeMode mode;
  final bool selected;
  final dynamic tokens;

  const _ModeCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.mode,
    required this.selected,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return GestureDetector(
      // context.read is correct inside onTap: we don't need the value here,
      // only need to dispatch the event. No rebuild triggered by the read.
      onTap: () => context.read<AppearanceSettingsCubit>().setThemeMode(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? Colors.blue.withOpacity(0.06)
              : c.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.blue : c.border.withOpacity(0.2),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.blue.withOpacity(0.12)
                    : Colors.grey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: selected ? Colors.blue : iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: tokens.typography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.blue : c.label,
                      )),
                  Text(subtitle,
                      style: tokens.typography.bodySmall
                          .copyWith(color: c.muted)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_rounded, color: Colors.blue, size: 20),
          ],
        ),
      ),
    );
  }
}