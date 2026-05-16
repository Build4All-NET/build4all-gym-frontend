import '../../../../../core/error/failures.dart';
import '../entities/member_qr_data.dart';
import '../repositories/member_qr_repository.dart';

/// Use case for loading member QR screen data.
///
/// Used by:
/// - LoadMemberQr event
///
/// Flow:
/// MemberQrBloc
/// -> GetMemberQrUseCase
/// -> MemberQrRepository
/// -> MemberQrRepositoryImpl
/// -> MemberQrService
/// -> GET /api/member/qr
///
/// Example:
/// final result = await getMemberQrUseCase();
///
/// if (result.data != null) {
///   // emit MemberQrLoaded
/// }
class GetMemberQrUseCase {
  final MemberQrRepository repository;

  const GetMemberQrUseCase({
    required this.repository,
  });

  Future<({MemberQrData? data, Failure? failure})> call() {
    return repository.getMemberQr();
  }
}