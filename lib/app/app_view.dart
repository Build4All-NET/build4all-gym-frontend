import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/auth/presentation/gate/auth_gate.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import 'app_router.dart';

class MyAppView extends StatelessWidget {
  final AppConfig appConfig;

  const MyAppView({super.key, required this.appConfig});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appConfig.appName.isNotEmpty ? appConfig.appName : 'Gym App',
          theme: themeState.themeData,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AuthGate(appConfig: appConfig),
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}