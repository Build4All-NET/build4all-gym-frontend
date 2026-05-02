
// ─────────────────────────────────────────────────────────────────────────────
// FILE: cancel_class_request_model.dart (same file for brevity)
//
// PURPOSE:
//   Request body for PATCH /api/admin/classes/{sessionId}/cancel.
//   cancelReason is optional — admin may cancel without typing a reason.
// ─────────────────────────────────────────────────────────────────────────────

class CancelClassRequestModel {
  final String? cancelReason;

  const CancelClassRequestModel({this.cancelReason});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (cancelReason != null) map['cancelReason'] = cancelReason;
    return map;
  }
}