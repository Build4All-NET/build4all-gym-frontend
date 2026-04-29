// lib/features/admin/navigation/presentation/cubit/drawer_state.dart

import 'package:equatable/equatable.dart';

class DrawerState extends Equatable {
  final String activeItemId;

  const DrawerState({this.activeItemId = 'dashboard'});

  DrawerState copyWith({String? activeItemId}) =>
      DrawerState(activeItemId: activeItemId ?? this.activeItemId);

  @override
  List<Object?> get props => [activeItemId];
}