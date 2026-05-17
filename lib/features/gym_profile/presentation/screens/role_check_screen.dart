// FILE: lib/features/gym_profile/presentation/screens/role_check_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/app/app_router.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import '../../data/repositories/gym_profile_repository_impl.dart';
import '../../data/services/gym_profile_service.dart';
import '../../domain/usecases/get_gym_profile_usecase.dart';
import '../cubit/gym_profile_cubit.dart';
import '../cubit/gym_profile_state.dart';

class RoleCheckScreen extends StatelessWidget {
  const RoleCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GymProfileCubit(
        GetGymProfileUseCase(
          GymProfileRepositoryImpl(
            GymProfileService(),
          ),
        ),
      )..fetchProfile(),
      child: const _RoleCheckBody(),
    );
  }
}

class _RoleCheckBody extends StatelessWidget {
  const _RoleCheckBody();

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;

    return BlocListener<GymProfileCubit, GymProfileState>(
      listener: (context, state) {
        if (state is GymProfileLoaded) {
          _routeByRoles(context, state.entity.gymRoles);
        }
        if (state is GymProfileError) {
          _routeByRoles(context, []); // safe fallback → member shell
        }
      },
      child: Scaffold(
        backgroundColor: c.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: c.primary),
              const SizedBox(height: 16),
              Text(
                'Loading your profile...',
                style: TextStyle(color: c.primary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _routeByRoles(BuildContext context, List<String> gymRoles) {
    final isTrainer   = gymRoles.contains('TRAINER');
    final isReception = gymRoles.contains('RECEPTION');

    if (isTrainer && !isReception) {
      // Trainer-only: bottom-tab trainer shell (no drawer needed)
      Navigator.pushReplacementNamed(context, AppRouter.adminPtSessions);
    } else if (isReception) {
      // Reception-only OR TRAINER+RECEPTION: land on the classes/operations screen.
      // The AdminNavigationDrawer shows Operations/Reception (and Training/PT when
      // the user also has TRAINER), so they can navigate from there.
      Navigator.pushReplacementNamed(context, AppRouter.adminClasses);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.user);
    }
  }
}