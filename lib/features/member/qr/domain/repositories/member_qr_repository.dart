import '../../../../../core/error/failures.dart';
import '../entities/member_qr_data.dart';

/// Repository contract for the member QR feature.
///
/// This belongs to the domain layer.
/// It defines what the QR feature needs without caring how data is fetched.
///
/// Flow:
/// BLoC
/// -> UseCase
/// -> MemberQrRepository
/// -> RepositoryImpl
/// -> Service
/// -> Backend
abstract class MemberQrRepository {
  /// Loads full QR screen data.
  ///
  /// Backend endpoint:
  /// GET /api/member/qr
  ///
  /// Returns:
  /// - QR token
  /// - expiration date
  /// - membership status
  /// - member code
  /// - package name
  /// - valid until
  /// - recent visits
  Future<({MemberQrData? data, Failure? failure})> getMemberQr();

  /// Forces QR token refresh.
  ///
  /// Backend endpoint:
  /// POST /api/member/qr/generate
  ///
  /// After backend generates a new QR token, the repository implementation
  /// will load GET /api/member/qr again to return the full screen data.
  Future<({MemberQrData? data, Failure? failure})> refreshMemberQr();
}