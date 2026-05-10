class UpdateProfileRequestModel {
  // Gym-owned member date of birth.
  final String? dateOfBirth;

  // Gym-owned member address.
  final String? address;

  // Gym-owned member gender.
  //
  // Expected values sent to Gym backend:
  // - MALE
  // - FEMALE
  // - OTHER
  // - PREFER_NOT_TO_SAY
  final String? gender;

  const UpdateProfileRequestModel({
    this.dateOfBirth,
    this.address,
    this.gender,
  });

  // Sent to:
  // PATCH /api/member/account/profile
  //
  // Gym backend owns only:
  // - dateOfBirth
  // - address
  // - gender
  Map<String, dynamic> toJson() {
    return {
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (address != null) 'address': address,
      if (gender != null) 'gender': gender,
    };
  }
}