// =============================================================================
// FILE: member_list_response_model.dart
// LAYER: Data Layer → Models
//
// FIX: Backend returns page as 0-based integer (page 0 = first page).
//      Flutter domain is 1-based. We add +1 here so the domain layer
//      and BLoC pagination logic never have to care about this difference.
//
// BACKEND RESPONSE SHAPE (MemberListResponse.java):
//   {
//     "items":      [ { ...MemberCardDto fields... } ],
//     "totalCount": 50,
//     "page":       0,     ← 0-based from backend
//     "size":       10,
//     "totalPages": 5
//   }
// =============================================================================

import 'member_card_model.dart';

class MemberListResponseModel {
  final List<MemberCardModel> items;
  final int totalCount;
  final int page;       // stored as 1-based after conversion
  final int size;
  final int totalPages;

  const MemberListResponseModel({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.size,
    required this.totalPages,
  });

  factory MemberListResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];

    return MemberListResponseModel(
      items: rawItems
          .map((item) => MemberCardModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int? ?? 0,

      // Backend is 0-based → convert to 1-based for Flutter domain layer.
      // page: 0 → 1, page: 1 → 2, etc.
      page:       (json['page'] as int? ?? 0) + 1,

      size:       json['size']       as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}