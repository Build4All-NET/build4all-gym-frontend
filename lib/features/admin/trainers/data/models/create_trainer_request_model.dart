// ─────────────────────────────────────────────────────────────────────────────
// create_trainer_request_model.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'trainer_availability_model.dart';
class CreateTrainerRequestModel {
  final String       fullName;
  final String?      email;
  final String?      phone;
  final String       password;
  final List<String> specialties;
  final List<int>    branchIds;
  final List<TrainerAvailabilityModel> availabilitySchedule;
  final int?         yearsOfExperience;
  final String?      notes;

  const CreateTrainerRequestModel({
    required this.fullName,
    this.email,
    this.phone,
    required this.password,
    required this.specialties,
    required this.branchIds,
    required this.availabilitySchedule,
    this.yearsOfExperience,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'fullName':             fullName,
    if (email  != null) 'email':  email,
    if (phone  != null) 'phone':  phone,
    'password':             password,
    'specialties':          specialties,
    'branchIds':            branchIds,
    'availabilitySchedule': availabilitySchedule.map((s) => s.toJson()).toList(),
    if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
    if (notes  != null) 'notes':  notes,
  };
}
