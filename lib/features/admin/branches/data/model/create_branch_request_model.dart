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
  final String? openingTime;   // null when isOpen24Hours is true
  final String? closingTime;   // null when isOpen24Hours is true
  final bool isOpen24Hours;
  final String status;         // "ACTIVE" | "INACTIVE"

  const CreateBranchRequestModel({
    required this.name,
    required this.city,
    required this.phone,
    required this.email,
    required this.address,
    this.openingTime,
    this.closingTime,
    this.isOpen24Hours = false,
    this.status = 'ACTIVE',
  });

  Map<String, dynamic> toJson() => {
    'name':          name,
    'city':          city,
    'phone':         phone,
    'email':         email,
    'address':       address,
    if (openingTime != null) 'openingTime': openingTime,
    if (closingTime != null) 'closingTime': closingTime,
    'isOpen24Hours': isOpen24Hours,
    'status':        status,
  };
}
