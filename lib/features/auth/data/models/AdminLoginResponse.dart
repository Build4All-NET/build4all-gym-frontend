class Adminloginresponse {
  final String token;
  final String tokenType;
  final String role;
  final int? ProjectOwnerId;

  Adminloginresponse({
    required this.token,
    required this.role,
    required this.ProjectOwnerId,
    required this.tokenType,
  });

  factory Adminloginresponse.fromjson(Map<String, dynamic> j) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    // ✅ Support wrapped payload: { message, data: {...} }
    Map<String, dynamic> data = j;
    final d1 = j['data'];
    if (d1 is Map) {
      data = Map<String, dynamic>.from(d1);

      // Sometimes nested again: { message, data: { data: {...} } }
      final d2 = data['data'];
      if (d2 is Map) {
        data = Map<String, dynamic>.from(d2 as Map);
      }
    }
    String pickToken(Map<String, dynamic> d) {
      return (d['token'] ?? d['accessToken'] ?? '').toString();
    }

    String pickTokenType(Map<String,dynamic> d){
      return (d['tokentype'] ?? d['tokenType'] ?? '').toString();
    }

    String pickRole(Map<String,dynamic> d){
      return (d['Role'] ?? d['roles'] ?? '').toString();
    }

    int? pickOwnerProjectId(Map<String,dynamic> d){
      return toInt((d['tenantId'] ?? d['OwnerProjectId']));
    }

    return Adminloginresponse(
        token: pickToken(data),
        role: pickRole(data),
        ProjectOwnerId: pickOwnerProjectId(data),
        tokenType: pickTokenType(data)
    );

  }
}
