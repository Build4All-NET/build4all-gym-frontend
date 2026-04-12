import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/config/app_config.dart';
import 'package:build4allgym/core/network/connecting(wifiORserver)/connection_cubit.dart';
import 'package:build4allgym/core/network/globals.dart' as g;
import 'package:build4allgym/core/realtime/realtime_cubit.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/auth/presentation/login/bloc/auth_bloc.dart';

import 'app_view.dart';

class MyApp extends StatelessWidget {
  final AppConfig appConfig;

  const MyApp({super.key, required this.appConfig});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => RealtimeCubit()),
        BlocProvider(
          create: (ctx) {
            final cubit = ConnectionCubit(connectivity: Connectivity());
            g.registerConnectionCubit(cubit);
            return cubit;
          },
        ),
      ],
      child: MyAppView(appConfig: appConfig),
    );
  }
}
