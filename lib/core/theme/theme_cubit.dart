import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../config/env.dart';
import '../runtime/runtime_config_service.dart';
import 'remote_theme_dto.dart';
import 'app_theme_tokens.dart';
import 'app_theme_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      menuType: 'bottom', // default
      selectedThemeMode: ThemeMode.system,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  final RuntimeConfigService _runtimeService;

  ThemeCubit({RuntimeConfigService? runtimeService})
      : _runtimeService = runtimeService ?? RuntimeConfigService(Dio()),
        super(ThemeState.initial()) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    // 1) Try compile-time theme first (CI baked)
    final envB64 = Env.themeJsonB64.trim();
    if (envB64.isNotEmpty) {
      _applyThemeFromB64(envB64, source: 'ENV');
      emit(state.copyWith(isLoaded: true));
      return;
    }

    // 2) No env theme => try runtime config from backend
    try {
      final apiBaseUrl = Env.apiBaseUrl.trim();
      final linkId = Env.ownerProjectLinkId.trim();

      if (apiBaseUrl.isEmpty || linkId.isEmpty) {
        // nothing we can do
        emit(state.copyWith(isLoaded: true));
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

      emit(state.copyWith(isLoaded: true));
    } catch (e) {
      // ignore: avoid_print
      print('Theme runtime load failed: $e');
      emit(state.copyWith(isLoaded: true));
    }

    // Load saved theme mode preference from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedModeName = prefs.getString('settings_theme_mode');
    if (savedModeName != null) {
      final savedMode = ThemeMode.values.firstWhere(
            (m) => m.name == savedModeName,
        orElse: () => ThemeMode.system,
      );
      emit(state.copyWith(selectedThemeMode: savedMode));
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
  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_theme_mode', mode.name);
    emit(state.copyWith(selectedThemeMode: mode));
  }
}
