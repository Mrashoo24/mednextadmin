import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? userId;
  String? fullName;
  String? email;
  String? password;
  String? state;
  String? photoUrl;
  String? city;
  List<String>? savedVideos;
  List<String>? registeredCourses;
  List<String>? registeredSubjects;

  UserModel(
      {this.userId,
      this.fullName,
      this.email,
      this.password,
      this.state,
      this.photoUrl,
      this.city,
      this.registeredCourses,
      this.registeredSubjects,
      this.savedVideos});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userId: json["userId"],
      fullName: json["fullName"],
      password: json["password"],
      email: json["email"],
      state: json["state"],
      photoUrl: json["photoUrl"],
      city: json["city"],
      savedVideos: json["savedVideos"] == null
          ? []
          : List<String>.from(json["savedVideos"].map((e) => e).toList()),
      registeredCourses: json["registeredCourses"] == null
          ? []
          : List<String>.from(json["registeredCourses"].map((e) => e).toList()),
      registeredSubjects: json["registeredSubjects"] == null
          ? []
          : List<String>.from(
                  json["registeredSubjects"].map((e) => e).toList()) ??
              []);

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "fullName": fullName,
        "password": password,
        "email": email,
        "state": state,
        "photoUrl": photoUrl,
        "city": city,
        "registeredCourses": registeredCourses ?? [],
        "registeredSubjects": registeredSubjects ?? [],
        "savedVideos": savedVideos ?? []
      };

  // CopyWith method
  UserModel copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? password,
    String? state,
    String? photoUrl,
    String? city,
    List<String>? registeredCourses,
    List<String>? registeredSubjects,
    List<String>? savedVideos,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      state: state ?? this.state,
      photoUrl: photoUrl ?? this.photoUrl,
      city: city ?? this.city,
      registeredCourses: registeredCourses ?? this.registeredCourses,
      registeredSubjects: registeredSubjects ?? this.registeredSubjects,
      savedVideos: savedVideos ?? this.savedVideos,
    );
  }
}
