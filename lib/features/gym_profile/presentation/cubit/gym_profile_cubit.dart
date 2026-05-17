// FILE: lib/features/gym_profile/presentation/cubit/gym_profile_cubit.dart
//
// LAYER: Presentation — Cubit
//
// PURPOSE:
//   Calls GetGymProfileUseCase after login.
//   Emits GymProfileLoaded with the entity so RoleCheckScreen can route.
//
// DI (how to wire in app_router.dart):
//   BlocProvider(
//     create: (_) => GymProfileCubit(
//       GetGymProfileUseCase(
//         GymProfileRepositoryImpl(
//           GymProfileService(),
//         ),
//       ),
//     ),
//   )

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_gym_profile_usecase.dart';
import 'gym_profile_state.dart';

class GymProfileCubit extends Cubit<GymProfileState> {
  final GetGymProfileUseCase _useCase;

  GymProfileCubit(this._useCase) : super(GymProfileInitial());

  /// Call immediately after a successful login.
  /// Guarded against double-calls (e.g. hot reload or multiple widget rebuilds).
  Future<void> fetchProfile() async {
    if (state is GymProfileLoading) return;
    emit(GymProfileLoading());

    try {
      final entity = await _useCase();
      emit(GymProfileLoaded(entity));
    } catch (e) {
      emit(GymProfileError(e.toString()));
    }
  }
}