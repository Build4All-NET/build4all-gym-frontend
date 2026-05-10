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
///   "minDaysPerWeek": 1,
///   "maxDaysPerWeek": 2,
///   "price": 160.00,
///   "salePrice": 140.00,
///   "finalPrice": 140.00
/// }
///
/// Important:
/// - name/packageType are display/metadata only.
/// - booking logic uses minDaysPerWeek/maxDaysPerWeek.
class PtPackageModel {
  final int id;
  final int trainerId;
  final int branchId;
  final String name;
  final String packageType;
  final int numberOfSessions;
  final int daysAvailable;
  final int minDaysPerWeek;
  final int maxDaysPerWeek;
  final double price;
  final double? salePrice;
  final double finalPrice;

  const PtPackageModel({
    required this.id,
    required this.trainerId,
    required this.branchId,
    required this.name,
    required this.packageType,
    required this.numberOfSessions,
    required this.daysAvailable,
    required this.minDaysPerWeek,
    required this.maxDaysPerWeek,
    required this.price,
    required this.salePrice,
    required this.finalPrice,
  });

  factory PtPackageModel.fromJson(Map<String, dynamic> json) {
    return PtPackageModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      trainerId: (json['trainerId'] as num?)?.toInt() ?? 0,
      branchId: (json['branchId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      packageType: json['packageType'] as String? ?? '',
      numberOfSessions: (json['numberOfSessions'] as num?)?.toInt() ?? 0,
      daysAvailable: (json['daysAvailable'] as num?)?.toInt() ?? 0,

      // New backend fields.
      // Defaults keep old API responses from crashing during transition.
      minDaysPerWeek: (json['minDaysPerWeek'] as num?)?.toInt() ?? 1,
      maxDaysPerWeek: (json['maxDaysPerWeek'] as num?)?.toInt() ?? 1,

      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ??
          (json['salePrice'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
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
      'minDaysPerWeek': minDaysPerWeek,
      'maxDaysPerWeek': maxDaysPerWeek,
      'price': price,
      'salePrice': salePrice,
      'finalPrice': finalPrice,
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
      minDaysPerWeek: minDaysPerWeek,
      maxDaysPerWeek: maxDaysPerWeek,
      price: price,
      salePrice: salePrice,
      finalPrice: finalPrice,
    );
  }
}