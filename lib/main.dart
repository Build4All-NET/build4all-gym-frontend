import 'package:flutter/material.dart';
import 'package:build4allgym/app/app.dart';
import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/network/globals.dart' as g;
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Dio for the GYM backend
  // Member home/account APIs are on PROJECT_API_BASE_URL = port 8980
  g.makeDefaultDio(Env.apiProjectBaseUrl);

  // 2. Restore saved token
  const tokenStore = AuthTokenStore();
  final saved = (await tokenStore.getToken())?.trim() ?? '';

  if (saved.isNotEmpty) {
    final raw = saved.toLowerCase().startsWith('bearer ')
        ? saved.substring(7).trim()
        : saved;

    if (raw.isNotEmpty) {
      g.setAuthToken(raw);
    }
  }

  // 3. Build AppConfig
  final appConfig = AppConfig.fromEnv();

  // 4. Run app
  runApp(MyApp(appConfig: appConfig));
}