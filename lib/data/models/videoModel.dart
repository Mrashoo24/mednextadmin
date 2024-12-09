class VideoModel {
  String? courseId;
  String? description;
  int? duration;
  int? ratings;
  String? subjectId;
  String? teacherId;
  String? thumbnail;
  String? title;
  String? uploadDate;
  String? url;
  String? videoId;
  bool? paid;
  bool? recommended;
  String? topicId;
  int? totalRating;
  List<String>? slides;
  String?  notes_pdf;

  VideoModel(
      {this.courseId,
      this.description,
      this.duration,
      this.ratings,
      this.subjectId,
      this.teacherId,
      this.thumbnail,
      this.title,
      this.uploadDate,
      this.url,
      this.videoId,
      this.paid,
      this.recommended,
      this.topicId,this.totalRating,this.slides,this.notes_pdf});

  VideoModel.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    description = json['description'];
    duration = json['duration'];
    ratings = json['ratings'];
    subjectId = json['subjectId'];
    teacherId = json['teacherId'];
    thumbnail = json['thumbnail'];
    title = json['title'];
    uploadDate = json['uploadDate'];
    url = json['url'];
    videoId = json['videoId'];
    paid = json['paid'];
    recommended = json['recommended'];
    topicId = json["topicId"];
    totalRating = json["totalRating"];
    notes_pdf = json["notes_pdf"];
    slides = json["slides"] == null
        ? []
        : List<String>.from(
        json["slides"].map((e) => e).toList()) ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['ratings'] = this.ratings;
    data['subjectId'] = this.subjectId;
    data['teacherId'] = this.teacherId;
    data['thumbnail'] = this.thumbnail;
    data['title'] = this.title;
    data['uploadDate'] = this.uploadDate;
    data['url'] = this.url;
    data['videoId'] = this.videoId;
    data['paid'] = this.paid;
    data['recommended'] = this.recommended;
    data["topicId"] = this.topicId;
    data["totalRating"] = this.totalRating;
    data["slides"] = this.slides;
    data["notes_pdf"] = this.notes_pdf;


    return data;
  }

  VideoModel copyWith(
      {String? courseId,
      String? description,
      int? duration,
      int? ratings,
      String? subjectId,
      String? teacherId,
      String? thumbnail,
      String? title,
      String? uploadDate,
      String? url,
      String? videoId,
      String? topicId,int? totalRating,bool? paid,List<String>? slides,String? notes_pdf}) {
    return VideoModel(
        courseId: courseId ?? this.courseId,
        description: description ?? this.description,
        duration: duration ?? this.duration,
        ratings: ratings ?? this.ratings,
        subjectId: subjectId ?? this.subjectId,
        teacherId: teacherId ?? this.teacherId,
        thumbnail: thumbnail ?? this.thumbnail,
        title: title ?? this.title,
        uploadDate: uploadDate ?? this.uploadDate,
        url: url ?? this.url,
        videoId: videoId ?? this.videoId,
        paid: paid ?? this.paid,
        topicId: topicId ?? this.topicId,totalRating:totalRating ?? this.totalRating,slides:slides ?? this.slides,notes_pdf:notes_pdf ?? this.notes_pdf);
  }
}
