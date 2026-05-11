import '../../domain/entities/pt_service_entity.dart';

class PtServiceModel extends PtServiceEntity {
  const PtServiceModel({
    required super.serviceId,
    required super.name,
    required super.description,
    required super.durationMinutes,
    required super.price,
    required super.isActive,
  });

  factory PtServiceModel.fromJson(Map<String, dynamic> json) {
    return PtServiceModel(
      serviceId: json['serviceId'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 60,
      price: (json['price'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'durationMinutes': durationMinutes,
    'price': price,
    'isActive': isActive,
  };
}