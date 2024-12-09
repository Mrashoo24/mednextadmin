class TopicModel {
  final String id;
  final String name;
  final String subjectId;

  TopicModel({required this.id, required this.name,required this.subjectId});

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      name: json['topicName'],
        subjectId:json["subjectId"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicName': name,
      'subjectId':subjectId
    };
  }

  // Copy with method
  TopicModel copyWith({String? id, String? name,String? subjectId}) {
    return TopicModel(
      id: id ?? this.id,
      name: name ?? this.name,
        subjectId:subjectId ?? this.subjectId
    );
  }
}