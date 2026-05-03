class BranchOptionModel {
  final int    id;
  final String name;

  const BranchOptionModel({required this.id, required this.name});

  factory BranchOptionModel.fromJson(Map<String, dynamic> json) =>
      BranchOptionModel(
        id:   json['id']   as int,
        name: json['name'] as String,
      );
}