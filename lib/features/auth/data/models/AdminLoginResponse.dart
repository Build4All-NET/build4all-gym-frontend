class Adminloginresponse {
  final String token;
  final String tokenType;
  final String role;
  final int? projectOwnerId;
  final String? refreshToken;
  final Map<String, dynamic>? admin; // full admin object from backend

  Adminloginresponse({
    required this.token,
    required this.role,
    required this.projectOwnerId,
    required this.tokenType,
    this.refreshToken,
    this.admin,
  });

  factory Adminloginresponse.fromjson(Map<String, dynamic> j) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    // Support wrapped payload: { message, data: {...} }
    Map<String, dynamic> data = j;
    final d1 = j['data'];
    if (d1 is Map) {
      data = Map<String, dynamic>.from(d1);
      final d2 = data['data'];
      if (d2 is Map) data = Map<String, dynamic>.from(d2 as Map);
    }

    String pickToken(Map<String, dynamic> d) =>
        (d['token'] ?? d['accessToken'] ?? '').toString();

    String pickTokenType(Map<String, dynamic> d) =>
        (d['tokentype'] ?? d['tokenType'] ?? 'Bearer').toString();

    String pickRole(Map<String, dynamic> d) =>
        (d['role'] ?? d['Role'] ?? d['roles'] ?? '').toString();

    int? pickOwnerProjectId(Map<String, dynamic> d) =>
        toInt(d['tenantId'] ?? d['ownerProjectId'] ?? d['OwnerProjectId']);

    String? pickRefreshToken(Map<String, dynamic> d) {
      final v = (d['refreshToken'] ?? d['refresh_token'] ?? '').toString();
      return v.trim().isEmpty ? null : v.trim();
    }

    Map<String, dynamic>? pickAdmin(Map<String, dynamic> d) {
      final a = d['admin'];
      if (a is Map) return Map<String, dynamic>.from(a);
      return null;
    }

    return Adminloginresponse(
      token: pickToken(data),
      role: pickRole(data),
      projectOwnerId: pickOwnerProjectId(data),
      tokenType: pickTokenType(data),
      refreshToken: pickRefreshToken(data),
      admin: pickAdmin(data),
    );
  }
}