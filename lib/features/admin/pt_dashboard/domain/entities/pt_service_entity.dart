class PtServiceEntity {
  final int serviceId;
  final String name;
  final String description;
  final int durationMinutes;
  final double price;
  final bool isActive;

  const PtServiceEntity({
    required this.serviceId,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.price,
    required this.isActive,
  });
}