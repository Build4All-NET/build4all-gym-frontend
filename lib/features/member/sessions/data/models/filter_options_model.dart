class FilterOptionsModel {
  final List<FilterOptionItemModel> classTypes;
  final List<FilterOptionItemModel> trainers;
  final List<FilterOptionItemModel> branches;

  const FilterOptionsModel({
    required this.classTypes,
    required this.trainers,
    required this.branches,
  });

  factory FilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionsModel(
      classTypes: (json['classTypes'] as List<dynamic>? ?? [])
          .map((item) => FilterOptionItemModel.fromJson(item))
          .toList(),
      trainers: (json['trainers'] as List<dynamic>? ?? [])
          .map((item) => FilterOptionItemModel.fromJson(item))
          .toList(),
      branches: (json['branches'] as List<dynamic>? ?? [])
          .map((item) => FilterOptionItemModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classTypes': classTypes.map((item) => item.toJson()).toList(),
      'trainers': trainers.map((item) => item.toJson()).toList(),
      'branches': branches.map((item) => item.toJson()).toList(),
    };
  }
}

class FilterOptionItemModel {
  final String id;
  final String name;

  const FilterOptionItemModel({
    required this.id,
    required this.name,
  });

  factory FilterOptionItemModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionItemModel(
      id: json['id'].toString(),
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}