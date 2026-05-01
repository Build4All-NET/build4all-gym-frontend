// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/data/models/class_form_options_model.dart
//
// PURPOSE:
//   Maps the response of GET /api/admin/classes/form-options.
//   Contains three lists — one per dropdown in the Add/Edit Class form.
//   ClassFormOptionItemModel is a reusable id+name pair used by all three lists.
// ─────────────────────────────────────────────────────────────────────────────

// ── Reusable dropdown item — used for types, trainers, AND branches ──────────
class ClassFormOptionItemModel {
  final int    id;   // classTypeId OR userId OR branchId
  final String name; // activity name OR trainer full name OR branch name

  const ClassFormOptionItemModel({required this.id, required this.name});

  factory ClassFormOptionItemModel.fromJson(Map<String, dynamic> json) {
    return ClassFormOptionItemModel(
      id:   json['id']   as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

// ── Full form-options response ────────────────────────────────────────────────
class ClassFormOptionsModel {
  final List<ClassFormOptionItemModel> classTypes; // Type/Activity dropdown
  final List<ClassFormOptionItemModel> trainers;   // Trainer dropdown
  final List<ClassFormOptionItemModel> branches;   // Branch dropdown

  const ClassFormOptionsModel({
    required this.classTypes,
    required this.trainers,
    required this.branches,
  });

  factory ClassFormOptionsModel.fromJson(Map<String, dynamic> json) {
    List<ClassFormOptionItemModel> _parseList(String key) {
      final raw = json[key] as List<dynamic>? ?? [];
      return raw
          .map((e) => ClassFormOptionItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return ClassFormOptionsModel(
      classTypes: _parseList('classTypes'),
      trainers:   _parseList('trainers'),
      branches:   _parseList('branches'),
    );
  }
}