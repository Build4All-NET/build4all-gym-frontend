// ─────────────────────────────────────────────────────────────────────────────
// lib/features/member/settings/data/repositories/member_settings_repository_impl.dart
//
// PURPOSE:
//   Concrete data-layer implementation of MemberSettingsRepository.
//
// ROLE:
//   The domain layer defines the repository contract.
//   This class implements that contract using the remote service.
//
// FLOW:
//   MemberSettingsCubit
//      → UseCase
//      → MemberSettingsRepository
//      → MemberSettingsRepositoryImpl
//      → MemberSettingsRemoteService
//      → Backend API
//
// SAME STRUCTURE AS ADMIN:
//   Admin has a repository implementation that calls the remote service,
//   converts data models to domain entities, and hides HTTP/JSON details
//   from the rest of the app.
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entities/member_settings_entity.dart';
import '../../domain/repositories/member_settings_repository.dart';
import '../models/member_settings_model.dart';
import '../services/member_settings_remote_service.dart';

class MemberSettingsRepositoryImpl implements MemberSettingsRepository {
  final MemberSettingsRemoteService remoteService;

  const MemberSettingsRepositoryImpl(this.remoteService);

  // ── GET settings ───────────────────────────────────────────────────────────

  /// Loads member settings from backend and maps model → entity.
  @override
  Future<MemberSettingsEntity> getSettings() async {
    final model = await remoteService.fetchSettings();
    return model.toEntity();
  }

  // ── PUT settings ───────────────────────────────────────────────────────────

  /// Maps entity → model, then sends it to backend.
  @override
  Future<void> updateSettings(MemberSettingsEntity settings) async {
    final model = MemberSettingsModel.fromEntity(settings);
    await remoteService.updateSettings(model);
  }
}