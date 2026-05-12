// ─────────────────────────────────────────────────────────────────────────────
// lib/common/settings/widgets/settings_version_footer.dart
//
// PURPOSE:
//   Displays the app name, version, and build number at the bottom of every
//   settings screen. Reads real values from package_info_plus at runtime.
//
// PLACEMENT: lib/common/settings/widgets/ (shared between admin + member)
//
// OUTPUT (matches Figma):
//   FitZone Gym Management
//   Version 1.0.0 • Build 2026.05
//
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/config/env.dart';
import '../../../core/theme/theme_cubit.dart';

class SettingsVersionFooter extends StatefulWidget {
  const SettingsVersionFooter({super.key});

  @override
  State<SettingsVersionFooter> createState() => _SettingsVersionFooterState();
}

class _SettingsVersionFooterState extends State<SettingsVersionFooter> {
  String _version = '1.0.0';
  String _buildNumber = '2026.05';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      // package_info_plus reads values from the native platform (Info.plist / AndroidManifest)
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = info.version;
          _buildNumber = info.buildNumber;
        });
      }
    } catch (_) {
      // Fallback to hardcoded values if package_info_plus fails (e.g. on web)
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;

    // Env.appName is the gym's display name baked in at build time (e.g. "FitZone Gym")
    // Falls back to "Gym Management" if the env variable is not set.
    final appName = Env.appName.isNotEmpty ? Env.appName : 'Gym Management';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            appName,
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Version $_version • Build $_buildNumber',
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.muted,
            ),
          ),
        ],
      ),
    );
  }
}