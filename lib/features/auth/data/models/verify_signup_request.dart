class VerifySignupRequest {
  final String email;
  final String code;

  VerifySignupRequest({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }
}