// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/availability_event.dart
//
// CHANGES vs previous version:
//   - AvailabilitySlotCreateRequested now carries an optional `specificDate`
//     (DateTime?) that must be provided when `recurring = false`.
//     DB column: trainer_availability.specific_date (date, nullable).
// =============================================================================

part of 'availability_bloc.dart';

abstract class AvailabilityEvent extends Equatable {
  const AvailabilityEvent();

  @override
  List<Object?> get props => [];
}

/// Load availability slots.
/// [trainerId] = null → admin mode (all trainers' slots).
/// [trainerId] = id   → trainer mode (own slots only).
class AvailabilitySlotsLoadRequested extends AvailabilityEvent {
  final int? trainerId;
  final int branchId;

  const AvailabilitySlotsLoadRequested({
    this.trainerId,
    required this.branchId,
  });

  @override
  List<Object?> get props => [trainerId, branchId];
}

/// Admin/owner creates a slot and assigns it to [trainerId].
///
/// When [recurring] = false, [specificDate] MUST be provided — it maps to
/// trainer_availability.specific_date in the DB.
class AvailabilitySlotCreateRequested extends AvailabilityEvent {
  final int trainerId;
  final int branchId;
  final int weekday;        // 1=Mon … 7=Sun
  final String startTime;  // "HH:mm"
  final String endTime;    // "HH:mm"
  final bool recurring;

  /// Only relevant when [recurring] = false.
  /// Maps to trainer_availability.specific_date (nullable date column).
  final DateTime? specificDate;

  const AvailabilitySlotCreateRequested({
    required this.trainerId,
    required this.branchId,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    this.recurring = true,
    this.specificDate,
  });

  @override
  List<Object?> get props => [
    trainerId, branchId, weekday, startTime, endTime,
    recurring, specificDate,
  ];
}

/// Delete a slot by its ID.
class AvailabilitySlotDeleteRequested extends AvailabilityEvent {
  final int availabilityId;

  const AvailabilitySlotDeleteRequested(this.availabilityId);

  @override
  List<Object?> get props => [availabilityId];
}
