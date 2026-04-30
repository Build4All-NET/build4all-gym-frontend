// =============================================================================
// FILE: member_list_response_model.dart
// LAYER: Data Layer → Models
// PURPOSE: Wraps the paginated API response for the members list endpoint.
//          The GET /api/admin/members endpoint returns:
//          { items: [...], totalCount: 50, page: 1, size: 10, totalPages: 5 }
//          This model parses that envelope + each item into MemberCardModel.
//
// POSITION IN FLOW:
//   API JSON Response
//     → [this file] MemberListResponseModel.fromJson()
//         → creates List<MemberCardModel> for each "items" entry
//     → AdminMembersRepositoryImpl maps it to MemberListResultEntity
//
// RELATED FILES:
//   ← Raw JSON from: admin_members_service.dart (getMembers)
//   ← Consumes:      member_card_model.dart (builds list of those)
//   → Mapped to:     member_list_result_entity.dart in repository impl
// =============================================================================

import 'member_card_model.dart';

class MemberListResponseModel {
  /// The paginated list of member cards for the current page.
  final List<MemberCardModel> items;

  /// Total number of members matching the current filter (across all pages).
  final int totalCount;

  /// Current page number (1-based from API).
  final int page;

  /// Number of items per page.
  final int size;

  /// Total number of pages available.
  final int totalPages;

  const MemberListResponseModel({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.size,
    required this.totalPages,
  });

  // ---------------------------------------------------------------------------
  // fromJson — parses the full paginated API response envelope.
  // The "items" key holds a JSON array; each element becomes a MemberCardModel.
  // ---------------------------------------------------------------------------
  factory MemberListResponseModel.fromJson(Map<String, dynamic> json) {
    // Safely parse the items array; fallback to empty list if key is missing.
    final rawItems = json['items'] as List<dynamic>? ?? [];

    return MemberListResponseModel(
      items: rawItems
          .map((item) => MemberCardModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}