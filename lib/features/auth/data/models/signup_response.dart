class SignupResponse {
  final String message;
  final String? token;

  SignupResponse({
    required this.message,
    this.token,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      message: json['message'] ?? '',
      token: json['token'],
    );
  }
}