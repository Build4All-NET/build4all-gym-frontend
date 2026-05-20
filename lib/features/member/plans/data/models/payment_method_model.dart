class PaymentMethodModel {
  final int id;
  final String name;
  final String displayName;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.displayName,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as int,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
    );
  }
}
