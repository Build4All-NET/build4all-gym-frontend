
class ClassFormOptionItemEntity {
  final int    id;
  final String name;

  const ClassFormOptionItemEntity({required this.id, required this.name});
}

// ─────────────────────────────────────────────────────────────────────────────
// FILE: class_form_options_entity.dart (same file)
// ─────────────────────────────────────────────────────────────────────────────

class ClassFormOptionsEntity {
  final List<ClassFormOptionItemEntity> classTypes;
  final List<ClassFormOptionItemEntity> trainers;
  final List<ClassFormOptionItemEntity> branches;

  const ClassFormOptionsEntity({
    required this.classTypes,
    required this.trainers,
    required this.branches,
  });
}