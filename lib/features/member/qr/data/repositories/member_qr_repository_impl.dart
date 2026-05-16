import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/member_qr_data.dart';
import '../../domain/repositories/member_qr_repository.dart';
import '../services/member_qr_service.dart';

/// Real implementation of MemberQrRepository.
///
/// This class belongs to the data layer.
///
/// Its job:
/// - call MemberQrService
/// - convert API model to domain entity
/// - convert exceptions to Failure objects
///
/// The BLoC should receive clean failures, not raw HTTP exceptions.
class MemberQrRepositoryImpl implements MemberQrRepository {
  final MemberQrService _service;

  const MemberQrRepositoryImpl({
    required MemberQrService service,
  }) : _service = service;

  /// Loads full QR screen data from:
  /// GET /api/member/qr
  @override
  Future<({MemberQrData? data, Failure? failure})> getMemberQr() async {
    try {
      final model = await _service.getMemberQr();

      return (
      data: model.toEntity(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }

  /// Forces QR refresh using:
  /// POST /api/member/qr/generate
  ///
  /// Then reloads:
  /// GET /api/member/qr
  ///
  /// Why reload?
  /// Because POST returns only token + expiresAt,
  /// but the screen needs full data:
  /// membershipStatus, packageName, memberCode, visits...
  @override
  Future<({MemberQrData? data, Failure? failure})> refreshMemberQr() async {
    try {
      await _service.refreshMemberQr();

      final model = await _service.getMemberQr();

      return (
      data: model.toEntity(),
      failure: null,
      );
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (
      data: null,
      failure: const AuthFailure('Access denied.'),
      );
    } on ServerException catch (e) {
      return (
      data: null,
      failure: ServerFailure(e.message),
      );
    } on NetworkException {
      return (
      data: null,
      failure: const NetworkFailure('No internet connection.'),
      );
    }
  }
}