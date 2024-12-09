class CourseModel {
  final String id;
  final String name;
  final String categoryid;
  final String questionTitle;
  final List<String> questionOptions;
  bool? isExpanded;

  CourseModel({required this.id, required this.name,this.isExpanded = false,required this.categoryid,this.questionOptions = const [],this.questionTitle = ""});

  factory CourseModel.fromJson(Map<String, dynamic> json) {

    return CourseModel(
      id: json['id'],
      name: json['name'],
        categoryid:json['categoryid'],
      questionOptions: List<String>.from(json['questionOptions'].map((e) => e.toString()).toList()) ,
      questionTitle:json['questionTitle'],

    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryid': categoryid,
      'questionOptions': questionOptions,
      'questionTitle': questionTitle,
    };
  }
  // Copy with method
  CourseModel copyWith({String? id, String? name}) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
        categoryid: categoryid ?? this.categoryid,
      questionOptions: questionOptions ?? this.questionOptions,
      questionTitle: questionTitle ?? this.questionTitle,

    );
  }
}