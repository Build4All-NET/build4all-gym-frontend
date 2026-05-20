class BranchOptionModel {
  final int    id;
  final String name;

  const BranchOptionModel({required this.id, required this.name});

  factory BranchOptionModel.fromJson(Map<String, dynamic> json) {
    return BranchOptionModel(
      id:   (json['id'] as num).toInt(),
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
