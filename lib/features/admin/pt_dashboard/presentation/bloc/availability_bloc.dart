
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/availability_service.dart';
import '../../data/models/availability_model.dart';

abstract class AvailabilityEvent {}
class LoadAvailability extends AvailabilityEvent {
  final int trainerId; final int branchId;
  LoadAvailability({required this.trainerId, required this.branchId});
}
class AddSlot extends AvailabilityEvent {
  final int trainerId; final int branchId;
  final int weekday; final String startTime; final String endTime;
  AddSlot({required this.trainerId, required this.branchId,
    required this.weekday, required this.startTime, required this.endTime});
}
class DeleteSlot extends AvailabilityEvent {
  final int availabilityId;
  DeleteSlot(this.availabilityId);
}

abstract class AvailabilityState {}
class AvailabilityInitial extends AvailabilityState {}
class AvailabilityLoading extends AvailabilityState {}
class AvailabilityLoaded extends AvailabilityState {
  final List<AvailabilityModel> slots;
  AvailabilityLoaded(this.slots);
}
class AvailabilityError extends AvailabilityState { final String message; AvailabilityError(this.message); }
class AvailabilityMutated extends AvailabilityState {}

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  final AvailabilityHttpService _svc;

  AvailabilityBloc(this._svc) : super(AvailabilityInitial()) {
    on<LoadAvailability>(_onLoad);
    on<AddSlot>(_onAdd);
    on<DeleteSlot>(_onDelete);
  }

  Future<void> _onLoad(LoadAvailability e, Emitter<AvailabilityState> emit) async {
    emit(AvailabilityLoading());
    try {
      emit(AvailabilityLoaded(
          await _svc.getSlots(trainerId: e.trainerId, branchId: e.branchId)));
    } catch (err) {
      emit(AvailabilityError(err.toString()));
    }
  }

  Future<void> _onAdd(AddSlot e, Emitter<AvailabilityState> emit) async {
    try {
      await _svc.createSlot(
          trainerId: e.trainerId, branchId: e.branchId,
          weekday: e.weekday, startTime: e.startTime, endTime: e.endTime);
      emit(AvailabilityMutated());
    } catch (err) {
      emit(AvailabilityError(err.toString()));
    }
  }

  Future<void> _onDelete(DeleteSlot e, Emitter<AvailabilityState> emit) async {
    try {
      await _svc.deleteSlot(e.availabilityId);
      emit(AvailabilityMutated());
    } catch (err) {
      emit(AvailabilityError(err.toString()));
    }
  }
}