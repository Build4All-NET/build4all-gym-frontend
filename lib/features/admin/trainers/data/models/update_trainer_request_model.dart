// ─────────────────────────────────────────────────────────────────────────────
// update_trainer_request_model.dart
// All fields nullable — only non-null are sent
// ─────────────────────────────────────────────────────────────────────────────
import 'trainer_availability_model.dart';
class UpdateTrainerRequestModel {
  final String?      fullName;
  final String?      email;
  final String?      phone;
  final String?      password;
  final List<String>? specialties;
  final List<int>?    branchIds;
  final List<TrainerAvailabilityModel>? availabilitySchedule;
  final int?         yearsOfExperience;
  final String?      notes;

  const UpdateTrainerRequestModel({
    this.fullName,
    this.email,
    this.phone,
    this.password,
    this.specialties,
    this.branchIds,
    this.availabilitySchedule,
    this.yearsOfExperience,
    this.notes,
  });

  // toJson excludes null fields — partial update
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (fullName            != null) map['fullName']             = fullName;
    if (email               != null) map['email']                = email;
    if (phone               != null) map['phone']                = phone;
    if (password            != null) map['password']             = password;
    if (specialties         != null) map['specialties']          = specialties;
    if (branchIds           != null) map['branchIds']            = branchIds;
    if (availabilitySchedule != null)
      map['availabilitySchedule'] =
          availabilitySchedule!.map((s) => s.toJson()).toList();
    if (yearsOfExperience   != null) map['yearsOfExperience']    = yearsOfExperience;
    if (notes               != null) map['notes']                = notes;
    return map;
  }
}