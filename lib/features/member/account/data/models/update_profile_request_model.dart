class UpdateProfileRequestModel {
  final String fullName;
  final String phone;
  final String? dateOfBirth;
  final String? address;

  const UpdateProfileRequestModel({
    required this.fullName,
    required this.phone,
    this.dateOfBirth,
    this.address,
  });

  // No fromJson() needed — this is a request model only.
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (address != null) 'address': address,
    };
  }
}