// ─────────────────────────────────────────────────────────────────────────────
// lib/common/settings/cubits/appearance_settings_cubit.dart
//
// PURPOSE:
//   A thin, standalone cubit that AppearanceSectionWidget connects to directly.
//   Lives in lib/common/ because it is shared between admin and member screens.
//
// WHY A SEPARATE CUBIT (not reading AdminSettingsCubit / MemberSettingsCubit):
//   AppearanceSectionWidget is in lib/common/ and must not import from either
//   feature. The only type it can safely context.watch is a common type.
//   This cubit IS that common type.
//
// HOW SCREENS WIRE IT UP:
//   Each settings screen (admin + member):
//     1. Creates AppearanceSettingsCubit, seeded with the current theme mode.
//     2. Wraps children in BlocProvider<AppearanceSettingsCubit>.
//     3. Adds a BlocListener<AppearanceSettingsCubit, ThemeMode> that
//        forwards changes to AdminSettingsCubit / MemberSettingsCubit.
//        This keeps a single source of truth (the main cubit) while
//        letting the widget stay fully decoupled.
//   See appearance_section_widget.dart for the widget side.
//   See admin_settings_screen.dart / member_settings_screen.dart for wiring.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppearanceSettingsCubit extends Cubit<ThemeMode> {
  AppearanceSettingsCubit({ThemeMode initial = ThemeMode.system})
      : super(initial);

  /// Selects a new theme mode. No-op if already selected (avoids dirty-flag
  /// false-positives when the screen re-seeds on hot reload / navigation).
  void setThemeMode(ThemeMode mode) {
    if (state == mode) return;
    emit(mode);
  }
}