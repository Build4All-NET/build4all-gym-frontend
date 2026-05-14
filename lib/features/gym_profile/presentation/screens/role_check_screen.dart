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
          _routeByRole(context, state.entity.gymRole);
        }
        if (state is GymProfileError) {
          _routeByRole(context, 'MEMBER'); // safe fallback
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

  void _routeByRole(BuildContext context, String gymRole) {
    switch (gymRole) {
      case 'TRAINER':
      // Trainer shell already exists at this route
        Navigator.pushReplacementNamed(context, AppRouter.adminPtSessions);
        break;
      case 'RECEPTION':
      // No reception shell yet — falls back to member for now
        Navigator.pushReplacementNamed(context, AppRouter.adminStaff);
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRouter.user);
        break;
    }
  }
}