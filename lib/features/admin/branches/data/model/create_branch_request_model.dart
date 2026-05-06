// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/branches/data/models/create_branch_request_model.dart
//
// Serialises the Add Branch form data into the POST /api/admin/branches body.
// ─────────────────────────────────────────────────────────────────────────────

class CreateBranchRequestModel {
  final String name;
  final String city;
  final String phone;
  final String email;
  final String address;
  final String openingTime;   // "HH:mm"
  final String closingTime;   // "HH:mm"
  final String status;        // "ACTIVE" | "INACTIVE"

  const CreateBranchRequestModel({
    required this.name,
    required this.city,
    required this.phone,
    required this.email,
    required this.address,
    required this.openingTime,
    required this.closingTime,
    this.status = 'ACTIVE',
  });

  Map<String, dynamic> toJson() => {
    'name':        name,
    'city':        city,
    'phone':       phone,
    'email':       email,
    'address':     address,
    'openingTime': openingTime,
    'closingTime': closingTime,
    'status':      status,
  };
}
 