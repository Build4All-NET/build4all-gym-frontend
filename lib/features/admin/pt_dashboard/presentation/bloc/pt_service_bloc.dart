import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/pt_service_service.dart';
import '../../data/models/pt_service_model.dart';

abstract class PtServiceEvent {}
class LoadServices extends PtServiceEvent { final int tenantId; LoadServices(this.tenantId); }
class CreateService extends PtServiceEvent {
  final int tenantId;
  final Map<String, dynamic> data;
  CreateService({required this.tenantId, required this.data});
}
class UpdateService extends PtServiceEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateService({required this.id, required this.data});
}

abstract class PtServiceState {}
class PtServiceInitial extends PtServiceState {}
class PtServiceLoading extends PtServiceState {}
class PtServiceLoaded extends PtServiceState {
  final List<PtServiceModel> services;
  PtServiceLoaded(this.services);
}
class PtServiceError extends PtServiceState { final String message; PtServiceError(this.message); }
class PtServiceMutated extends PtServiceState {}

class PtServiceBloc extends Bloc<PtServiceEvent, PtServiceState> {
  final PtServiceService _svc;

  PtServiceBloc(this._svc) : super(PtServiceInitial()) {
    on<LoadServices>(_onLoad);
    on<CreateService>(_onCreate);
    on<UpdateService>(_onUpdate);
  }

  Future<void> _onLoad(LoadServices e, Emitter<PtServiceState> emit) async {
    emit(PtServiceLoading());
    try {
      emit(PtServiceLoaded(await _svc.getServices(e.tenantId)));
    } catch (err) {
      emit(PtServiceError(err.toString()));
    }
  }

  Future<void> _onCreate(CreateService e, Emitter<PtServiceState> emit) async {
    try {
      await _svc.createService(e.tenantId, e.data);
      emit(PtServiceMutated());
    } catch (err) {
      emit(PtServiceError(err.toString()));
    }
  }

  Future<void> _onUpdate(UpdateService e, Emitter<PtServiceState> emit) async {
    try {
      await _svc.updateService(e.id, e.data);
      emit(PtServiceMutated());
    } catch (err) {
      emit(PtServiceError(err.toString()));
    }
  }
}