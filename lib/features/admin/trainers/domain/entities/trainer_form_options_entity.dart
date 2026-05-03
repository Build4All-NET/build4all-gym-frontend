// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/trainers/domain/entities/trainer_form_options_entity.dart
// ─────────────────────────────────────────────────────────────────────────────
class ClassFormOptionItemEntity {
  final int    id;
  final String name;
  const ClassFormOptionItemEntity({required this.id, required this.name});
}

class TrainerFormOptionsEntity {
  final List<String>                    specialties;
  final List<ClassFormOptionItemEntity> branches;
  const TrainerFormOptionsEntity({
    required this.specialties,
    required this.branches,
  });
}

 