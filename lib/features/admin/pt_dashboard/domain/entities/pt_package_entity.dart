class PtPackageEntity {
  final int id;
  final String name;
  final String packageType;
  final int numberOfSessions;
  final int daysAvailable;
  final int minDaysPerWeek;
  final int maxDaysPerWeek;
  final double price;
  final double? salePrice;
  final bool active;

  const PtPackageEntity({
    required this.id,
    required this.name,
    required this.packageType,
    required this.numberOfSessions,
    required this.daysAvailable,
    required this.minDaysPerWeek,
    required this.maxDaysPerWeek,
    required this.price,
    this.salePrice,
    required this.active,
  });

  double get effectivePrice => salePrice ?? price;
  double get savings => salePrice != null ? price - salePrice! : 0;
}