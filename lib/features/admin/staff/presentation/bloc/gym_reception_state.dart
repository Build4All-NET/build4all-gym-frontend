import '../../domain/entities/gym_reception_entity.dart';

abstract class GymReceptionState {}

class GymReceptionInitial  extends GymReceptionState {}
class GymReceptionLoading  extends GymReceptionState {}

class GymReceptionLoaded extends GymReceptionState {
  final List<GymReceptionEntity> staff;
  GymReceptionLoaded(this.staff);
}

class GymReceptionError extends GymReceptionState {
  final String message;
  GymReceptionError(this.message);
}

class GymReceptionRemoving extends GymReceptionState {
  final List<GymReceptionEntity> staff;
  final int removingUserId;
  GymReceptionRemoving(this.staff, this.removingUserId);
}

class GymReceptionRemoveError extends GymReceptionState {
  final List<GymReceptionEntity> staff;
  final String message;
  GymReceptionRemoveError(this.staff, this.message);
}
