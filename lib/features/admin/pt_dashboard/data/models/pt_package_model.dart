import '../../domain/entities/pt_package_entity.dart';

class PtPackageModel extends PtPackageEntity {
  const PtPackageModel({
    required super.id,
    required super.name,
    required super.packageType,
    required super.numberOfSessions,
    required super.daysAvailable,
    required super.minDaysPerWeek,
    required super.maxDaysPerWeek,
    required super.price,
    super.salePrice,
    required super.active,
  });

  factory PtPackageModel.fromJson(Map<String, dynamic> json) {
    return PtPackageModel(
      id: json['id'] as int,
      name: json['name'] as String,
      packageType: json['packageType'] as String? ?? 'CUSTOM',
      numberOfSessions: json['numberOfSessions'] as int,
      daysAvailable: json['daysAvailable'] as int,
      minDaysPerWeek: json['minDaysPerWeek'] as int,
      maxDaysPerWeek: json['maxDaysPerWeek'] as int,
      price: (json['price'] as num).toDouble(),
      salePrice: json['salePrice'] != null
          ? (json['salePrice'] as num).toDouble()
          : null,
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'packageType': packageType,
    'numberOfSessions': numberOfSessions,
    'daysAvailable': daysAvailable,
    'minDaysPerWeek': minDaysPerWeek,
    'maxDaysPerWeek': maxDaysPerWeek,
    'price': price,
    if (salePrice != null) 'salePrice': salePrice,
    'active': active,
  };
}