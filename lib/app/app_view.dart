import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/core/localization/locale_cubit.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/auth/presentation/gate/auth_gate.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../core/theme/app_theme_builder.dart';
import 'app_router.dart';

class MyAppView extends StatelessWidget {
  final AppConfig appConfig;

  const MyAppView({
    super.key,
    required this.appConfig,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LocaleCubit, Locale?>(
          builder: (context, locale) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: appConfig.appName.isNotEmpty
                  ? appConfig.appName
                  : 'Gym App',

              themeMode: themeState.selectedThemeMode,
              theme: AppThemeBuilder.build(themeState.tokens),

              locale: locale,
              localizationsDelegates:
              AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,

              home: AuthGate(appConfig: appConfig),
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        );
      },
    );
  }
}