import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/gym_reception_entity.dart';
import '../../domain/usecases/gym_reception_usecases.dart';
import 'gym_reception_state.dart';

class GymReceptionCubit extends Cubit<GymReceptionState> {
  final GetGymReceptionUseCase    _getReception;
  final RemoveGymReceptionUseCase _removeReception;

  GymReceptionCubit({
    required GetGymReceptionUseCase getReception,
    required RemoveGymReceptionUseCase removeReception,
  })  : _getReception  = getReception,
        _removeReception = removeReception,
        super(GymReceptionInitial());

  Future<void> load() async {
    emit(GymReceptionLoading());
    try {
      final staff = await _getReception();
      emit(GymReceptionLoaded(staff));
    } catch (e) {
      emit(GymReceptionError(e.toString()));
    }
  }

  Future<void> reload() => load();

  Future<void> removeReception(int userId) async {
    final currentStaff = _currentList();
    emit(GymReceptionRemoving(currentStaff, userId));
    try {
      await _removeReception(userId);
      final updated = currentStaff.where((s) => s.userId != userId).toList();
      emit(GymReceptionLoaded(updated));
    } catch (e) {
      emit(GymReceptionRemoveError(currentStaff, 'Could not remove reception role. Try again.'));
    }
  }

  List<GymReceptionEntity> _currentList() {
    final s = state;
    if (s is GymReceptionLoaded)      return s.staff;
    if (s is GymReceptionRemoving)    return s.staff;
    if (s is GymReceptionRemoveError) return s.staff;
    return [];
  }
}
