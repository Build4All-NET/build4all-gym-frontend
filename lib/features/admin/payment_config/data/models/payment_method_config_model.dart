class PaymentMethodConfigModel {
  final int id;
  final String name;
  final String displayName;
  final bool globallyEnabled;
  final bool tenantEnabled;
  final String? configJson;
  final Map<String, dynamic>? configSchema;

  PaymentMethodConfigModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.globallyEnabled,
    required this.tenantEnabled,
    this.configJson,
    this.configSchema,
  });

  factory PaymentMethodConfigModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodConfigModel(
      id:              json['id'] as int,
      name:            json['name'] as String,
      displayName:     json['displayName'] as String,
      globallyEnabled: json['globallyEnabled'] as bool,
      tenantEnabled:   json['tenantEnabled'] as bool,
      configJson:      json['configJson'] as String?,
      configSchema:    json['configSchema'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toSaveJson() => {
        'enabled':    tenantEnabled,
        'configJson': configJson,
      };

  PaymentMethodConfigModel copyWith({bool? tenantEnabled, String? configJson}) {
    return PaymentMethodConfigModel(
      id:              id,
      name:            name,
      displayName:     displayName,
      globallyEnabled: globallyEnabled,
      tenantEnabled:   tenantEnabled ?? this.tenantEnabled,
      configJson:      configJson ?? this.configJson,
      configSchema:    configSchema,
    );
  }
}
