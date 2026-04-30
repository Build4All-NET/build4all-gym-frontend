
// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/navigation/presentation/cubit/drawer_cubit.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawer_state.dart';
/// Tracks which nav item is currently active (highlighted).
/// Cubit is correct here — drawer selection is simple one-direction state,
/// no async effects, no error states.
class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit({String initialActiveId = 'dashboard'})
      : super(DrawerState(activeItemId: initialActiveId));

  void selectItem(String itemId) {
    if (state.activeItemId == itemId) return;
    emit(state.copyWith(activeItemId: itemId));
  }
}