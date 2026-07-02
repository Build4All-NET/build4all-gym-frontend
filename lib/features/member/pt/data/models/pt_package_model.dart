import '../../domain/entities/pt_package_entity.dart';

/// Data-layer model for PT package JSON returned by backend.
///
/// Backend sends this inside trainer detail:
///
/// {
///   "id": 1,
///   "trainerId": 5,
///   "branchId": 1,
///   "name": "باقة أسبوع",
///   "packageType": "CUSTOM",
///   "numberOfSessions": 4,
///   "daysAvailable": 7,
///   "sessionDurationMinutes": 60,
///   "minDaysPerWeek": 1,
///   "maxDaysPerWeek": 2,
///   "price": 160.00,
///   "salePrice": 140.00,
///   "finalPrice": 140.00,
///   "bookingStatus": "PENDING"
/// }
///
/// Important:
/// - name/packageType are display/metadata only.
/// - booking logic uses minDaysPerWeek/maxDaysPerWeek.
/// - bookingStatus belongs to this exact package.
class PtPackageModel {
  final int id;
  final int trainerId;
  final int branchId;

  final String name;
  final String packageType;

  final int numberOfSessions;
  final int daysAvailable;
  final int? sessionDurationMinutes;

  final int minDaysPerWeek;
  final int maxDaysPerWeek;

  final double price;
  final double? salePrice;
  final double finalPrice;

  final String bookingStatus;

  const PtPackageModel({
    required this.id,
    required this.trainerId,
    required this.branchId,
    required this.name,
    required this.packageType,
    required this.numberOfSessions,
    required this.daysAvailable,
    this.sessionDurationMinutes,
    required this.minDaysPerWeek,
    required this.maxDaysPerWeek,
    required this.price,
    required this.salePrice,
    required this.finalPrice,
    required this.bookingStatus,
  });

  factory PtPackageModel.fromJson(Map<String, dynamic> json) {
    return PtPackageModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      trainerId: (json['trainerId'] as num?)?.toInt() ?? 0,
      branchId: (json['branchId'] as num?)?.toInt() ?? 0,

      name: json['name'] as String? ?? '',
      packageType: json['packageType'] as String? ?? '',

      numberOfSessions:
      (json['numberOfSessions'] as num?)?.toInt() ?? 0,

      daysAvailable:
      (json['daysAvailable'] as num?)?.toInt() ?? 0,

      sessionDurationMinutes:
      (json['sessionDurationMinutes'] as num?)?.toInt(),

      // Defaults keep older backend responses from crashing.
      minDaysPerWeek:
      (json['minDaysPerWeek'] as num?)?.toInt() ?? 1,

      maxDaysPerWeek:
      (json['maxDaysPerWeek'] as num?)?.toInt() ?? 1,

      price:
      (json['price'] as num?)?.toDouble() ?? 0.0,

      salePrice:
      (json['salePrice'] as num?)?.toDouble(),

      finalPrice:
      (json['finalPrice'] as num?)?.toDouble() ??
          (json['salePrice'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,

      bookingStatus:
      (json['bookingStatus'] as String?)
          ?.trim()
          .toUpperCase() ??
          'NONE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trainerId': trainerId,
      'branchId': branchId,
      'name': name,
      'packageType': packageType,
      'numberOfSessions': numberOfSessions,
      'daysAvailable': daysAvailable,
      'sessionDurationMinutes': sessionDurationMinutes,
      'minDaysPerWeek': minDaysPerWeek,
      'maxDaysPerWeek': maxDaysPerWeek,
      'price': price,
      'salePrice': salePrice,
      'finalPrice': finalPrice,
      'bookingStatus': bookingStatus,
    };
  }

  PtPackageEntity toEntity() {
    return PtPackageEntity(
      id: id,
      trainerId: trainerId,
      branchId: branchId,
      name: name,
      packageType: packageType,
      numberOfSessions: numberOfSessions,
      daysAvailable: daysAvailable,
      sessionDurationMinutes: sessionDurationMinutes,
      minDaysPerWeek: minDaysPerWeek,
      maxDaysPerWeek: maxDaysPerWeek,
      price: price,
      salePrice: salePrice,
      finalPrice: finalPrice,
      bookingStatus: bookingStatus,
    );
  }
}