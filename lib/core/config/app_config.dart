import '../config/env.dart';

class AppConfig {
  final int? ownerProjectId;
  final String appName;
  final String appLogoUrl;
  final String menuType;
  final String appType;
  final String appRole;

  const AppConfig({
    this.ownerProjectId,
    this.appName = 'B-PRO',
    this.appLogoUrl = '',
    this.menuType = 'bottom',
    this.appType = 'ACTIVITIES',
    this.appRole = 'both',
  });

  factory AppConfig.fromEnv() {
    return AppConfig(
      ownerProjectId: int.tryParse(Env.ownerProjectLinkId),
      appName: Env.appName,
      appLogoUrl: Env.appLogoUrl,
      menuType: Env.menuType,
      appType: Env.appType,
      appRole: Env.appRole,
    );
  }
}