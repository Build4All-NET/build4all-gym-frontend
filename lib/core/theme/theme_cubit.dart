import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/env.dart';
import '../runtime/runtime_config_service.dart';
import 'remote_theme_dto.dart';
import 'app_theme_tokens.dart';
import 'app_theme_builder.dart';

class ThemeState {
  final ThemeData themeData;
  final AppThemeTokens tokens;
  final bool isLoaded;
  final ThemeMode selectedThemeMode; // default: ThemeMode.system

  final String menuType; // "bottom", "drawer", etc.

  const ThemeState({
    required this.themeData,
    required this.tokens,
    required this.isLoaded,
    required this.menuType,
    required this.selectedThemeMode,
  });

  ThemeState copyWith({
    ThemeData? themeData,
    AppThemeTokens? tokens,
    bool? isLoaded,
    String? menuType,
    ThemeMode? selectedThemeMode,
  }) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
      tokens: tokens ?? this.tokens,
      isLoaded: isLoaded ?? this.isLoaded,
      menuType: menuType ?? this.menuType,
        selectedThemeMode:selectedThemeMode ?? this.selectedThemeMode,
    );
  }

  factory ThemeState.initial() {
    final tokens = AppThemeTokens.fallback();
    return ThemeState(
      themeData: AppThemeBuilder.build(tokens),
      tokens: tokens,
      isLoaded: false,
      menuType: 'bottom',
      selectedThemeMode: ThemeMode.light,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  final RuntimeConfigService _runtimeService;

  static const _themeModeKey = 'theme_mode';

  ThemeCubit({RuntimeConfigService? runtimeService})
      : _runtimeService = runtimeService ?? RuntimeConfigService(Dio()),
        super(ThemeState.initial()) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    // Load persisted theme mode from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedModeStr = prefs.getString(_themeModeKey);
    final savedMode = savedModeStr == 'dark'
        ? ThemeMode.dark
        : savedModeStr == 'system'
            ? ThemeMode.system
            : ThemeMode.light;

    // ── Apply the visual theme from env or runtime ────────────────────────────
    final envB64 = Env.themeJsonB64.trim();
    if (envB64.isNotEmpty) {
      _applyThemeFromB64(envB64, source: 'ENV');
      emit(state.copyWith(isLoaded: true, selectedThemeMode: savedMode));
      return;
    }

    try {
      final apiBaseUrl = Env.apiBaseUrl.trim();
      final linkId = Env.ownerProjectLinkId.trim();
      if (apiBaseUrl.isEmpty || linkId.isEmpty) {
        emit(state.copyWith(isLoaded: true, selectedThemeMode: savedMode));
        return;
      }
      final cfg = await _runtimeService.fetchByLinkId(
        apiBaseUrl: apiBaseUrl,
        linkId: linkId,
      );
      final runtimeB64 = (cfg['THEME_JSON_B64'] ?? '').toString().trim();
      if (runtimeB64.isNotEmpty) {
        _applyThemeFromB64(runtimeB64, source: 'RUNTIME');
      }
      emit(state.copyWith(isLoaded: true, selectedThemeMode: savedMode));
    } catch (e) {
      print('Theme runtime load failed: $e');
      emit(state.copyWith(isLoaded: true, selectedThemeMode: savedMode));
    }
  }

  void _applyThemeFromB64(String b64, {required String source}) {
    try {
      print('Applying theme from $source (len=${b64.length})');

      final remote = RemoteThemeDto.fromBase64Json(b64);
      final tokens = AppThemeTokens.fromRemote(remote);
      final themeData = AppThemeBuilder.build(tokens);

      emit(
        state.copyWith(
          themeData: themeData,
          tokens: tokens,
          isLoaded: true,
          menuType: (remote.menuType ?? 'bottom').toLowerCase(),
        ),
      );
    } catch (e) {
      print('Theme apply failed ($source): $e');
    }
  }
  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(selectedThemeMode: mode));
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setString(_themeModeKey, _modeToString(mode)),
    );
  }

  String _modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      default:
        return 'light';
    }
  }
}
