// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/shared/data/models/branch_option_model.dart
//
// Maps the GET /api/admin/branches/options response.
// Backend returns: [ { "id": "uuid-or-numeric", "name": "Branch Name" }, … ]
//
// id is parsed safely — handles both numeric string ("1") and UUID string.
// The cubit's branchById(int id) method compares against the numeric value
// when available; UUID-only branches get id = 0 as a safe fallback.
// ─────────────────────────────────────────────────────────────────────────────

class BranchOptionModel {
  final int id;
  final String name;

  const BranchOptionModel({required this.id, required this.name});

  factory BranchOptionModel.fromJson(Map<String, dynamic> json) {
    // id can arrive as int (123), double (123.0), or String ("123" / "uuid")
    final rawId = json['id'];
    int parsedId;
    if (rawId is int) {
      parsedId = rawId;
    } else if (rawId is double) {
      parsedId = rawId.toInt();
    } else if (rawId is String) {
      parsedId = int.tryParse(rawId) ?? 0;
    } else {
      parsedId = 0;
    }

    return BranchOptionModel(
      id:   parsedId,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}