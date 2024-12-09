class CategoryModel {
  final String id;
  final String name;
  bool? isExpanded;

  CategoryModel({required this.id, required this.name,this.isExpanded = false});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Copy with method
  CategoryModel copyWith({String? id, String? name}) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}