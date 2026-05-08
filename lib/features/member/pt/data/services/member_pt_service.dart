import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/config/env.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../auth/data/services/auth_token_store.dart';
import '../models/trainer_list_response_model.dart';
import '../models/trainer_filter_options_model.dart';
import '../models/toggle_favorite_response_model.dart';
import '../models/trainer_detail_model.dart';
import '../models/time_slot_model.dart';

class MemberPtService {
  final AuthTokenStore _tokenStore;

  MemberPtService() : _tokenStore = const AuthTokenStore();

  // ── GET /api/member/trainers ─────────────────────────────────────────────
  // Optional filters: specialtyFilter and favoritesOnly.
  // branchId is NOT passed — backend resolves from member's active membership.
  Future<TrainerListResponseModel> getTrainers({
    String? specialtyFilter,
    bool favoritesOnly = false,
  }) async {
    final token = await _tokenStore.getToken();

    if (token == null || token.trim().isEmpty) {
      throw UnauthorizedException();
    }

    final queryParams = <String, String>{
      'favoritesOnly': favoritesOnly.toString(),
      if (specialtyFilter != null && specialtyFilter.isNotEmpty)
        'specialtyFilter': specialtyFilter,
    };

    final uri = Uri.parse('${Env.apiProjectBaseUrl}/api/member/trainers')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
        },
      );

      if (response.statusCode == 200) {
        return TrainerListResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  // ── GET /api/member/trainers/filter-options ──────────────────────────────
  // Returns specialties from trainers at the member's active branch.
  // الكل and المفضلة are hardcoded client-side — not returned by backend.
  Future<TrainerFilterOptionsModel> getFilterOptions() async {
    final token = await _tokenStore.getToken();

    if (token == null || token.trim().isEmpty) {
      throw UnauthorizedException();
    }

    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/member/trainers/filter-options');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
        },
      );

      if (response.statusCode == 200) {
        return TrainerFilterOptionsModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  // ── POST /api/member/trainers/{trainerId}/favorite ───────────────────────
  // Toggles favorite state.
  // Returns isFavorited so BLoC updates only that card without reloading list.
  Future<ToggleFavoriteResponseModel> toggleFavoriteTrainer(int trainerId) async {
    final token = await _tokenStore.getToken();

    if (token == null || token.trim().isEmpty) {
      throw UnauthorizedException();
    }

    final uri = Uri.parse(
        '${Env.apiProjectBaseUrl}/api/member/trainers/$trainerId/favorite');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
        },
      );

      if (response.statusCode == 200) {
        return ToggleFavoriteResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  // ── GET /api/member/trainers/{trainerId} ─────────────────────────────────
  // Returns full trainer profile:
  // name, specialty, rating, price, certifications, assignedVideos, etc.
  Future<TrainerDetailModel> getTrainerDetail(int trainerId) async {
    debugPrint('ENTERED getTrainerDetail with trainerId: $trainerId');
    final token = await _tokenStore.getToken();


    if (token == null || token.trim().isEmpty) {
      throw UnauthorizedException();
    }

    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/member/trainers/$trainerId',
    );

    debugPrint('DETAIL URI: $uri');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
        },
      );

      if (response.statusCode == 200) {
        return TrainerDetailModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }
  // ── GET /api/trainers/{trainerId}/slots?date=YYYY-MM-DD ────────────────
  // Returns available PT time slots for a selected trainer and date.
  Future<List<TimeSlotModel>> getAvailableSlots({
    required int trainerId,
    required DateTime date,
  }) async {
    final token = await _tokenStore.getToken();

    if (token == null || token.trim().isEmpty) {
      throw UnauthorizedException();
    }

    final formattedDate = _formatDate(date);

    final uri = Uri.parse(
      '${Env.apiProjectBaseUrl}/api/trainers/$trainerId/slots',
    ).replace(
      queryParameters: {
        'date': formattedDate,
      },
    );

    debugPrint('SLOTS URI: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'X-Owner-Project-Link-Id': Env.ownerProjectLinkId,
        },
      );

      debugPrint('SLOTS STATUS: ${response.statusCode}');
      debugPrint('SLOTS BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is! List) {
          throw ServerException(message: 'Invalid slots response.');
        }

        return decoded
            .map(
              (item) => TimeSlotModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
            .toList();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      if (e is UnauthorizedException ||
          e is ForbiddenException ||
          e is ServerException) {
        rethrow;
      }

      throw NetworkException();
    }
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

}