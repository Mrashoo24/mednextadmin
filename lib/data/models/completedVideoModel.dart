class CompletedVideosModel {
  String? courseId;
  String? date;
  String? id;
  String? subjectId;
  String? topicId;
  String? uid;
  String? teacherId;
  int? rating;
  String? review;

  CompletedVideosModel(
      {this.courseId,
        this.date,
        this.id,
        this.subjectId,
        this.topicId,
        this.uid,
        this.teacherId,this.rating,this.review});

  CompletedVideosModel.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    date = json['date'];
    id = json['id'];
    subjectId = json['subjectId'];
    topicId = json['topicId'];
    uid = json['uid'];
    teacherId = json['teacherId'];
    rating = json["rating"];
    review = json["review"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    data['date'] = this.date;
    data['id'] = this.id;
    data['subjectId'] = this.subjectId;
    data['topicId'] = this.topicId;
    data['uid'] = this.uid;
    data['teacherId'] = this.teacherId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    return data;
  }
}
