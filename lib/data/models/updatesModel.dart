class UpdatesModel {
  String? title;
  String? subtitle;
  String? duration;
  String? uploadDate;
  String? link;

  UpdatesModel(
      {this.title, this.subtitle, this.duration, this.uploadDate, this.link});

  UpdatesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    duration = json['duration'];
    uploadDate = json['uploadDate'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['duration'] = this.duration;
    data['uploadDate'] = this.uploadDate;
    data['link'] = this.link;
    return data;
  }
}
