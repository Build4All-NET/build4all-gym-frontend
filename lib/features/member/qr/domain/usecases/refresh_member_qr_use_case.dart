import '../../../../../core/error/failures.dart';
import '../entities/member_qr_data.dart';
import '../repositories/member_qr_repository.dart';

/// Use case for refreshing the member QR token.
///
/// Used by:
/// - RefreshMemberQr event
/// - auto-refresh timer inside MemberQrBloc
/// - pull-to-refresh from UI later
///
/// Flow:
/// MemberQrBloc
/// -> RefreshMemberQrUseCase
/// -> MemberQrRepository
/// -> MemberQrRepositoryImpl
/// -> MemberQrService
/// -> POST /api/member/qr/generate
/// -> GET /api/member/qr
///
/// Why POST then GET?
/// Backend POST returns only:
/// - token
/// - expiresAt
///
/// But the QR screen needs full data:
/// - membershipStatus
/// - memberCode
/// - packageName
/// - validUntil
/// - recentVisits
class RefreshMemberQrUseCase {
  final MemberQrRepository repository;

  const RefreshMemberQrUseCase({
    required this.repository,
  });

  Future<({MemberQrData? data, Failure? failure})> call() {
    return repository.refreshMemberQr();
  }
}