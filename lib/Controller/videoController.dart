import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import '../../data/models/videoModel.dart';
import '../data/models/completedVideoModel.dart';

class VideoController extends GetxController {
  List<VideoModel> videos = [];
  List<CompletedVideosModel> completedVideos = [];

  bool videoloading = false;

 bool? sendLoading = false;
  bool? pdfLoading = false;

  VideoModel? selectedVideoModel ;
  List<VideoModel>? recommendedVideoList = [];

  // Call this method to load cached data initially
  void loadCachedData() {
      getVideos();


  }

  Future<void> getVideos() async {
    if (videos.isEmpty) {
      videoloading = true;
      update();
    }

    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('videos').get();

      // Map Firestore data to Video model
      videos = querySnapshot.docs
          .map((doc) => VideoModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Cache the fetched videos
      // box.write('videos', videos.map((video) => video.toJson()).toList());

      update();
    } catch (e) {
      print("Error fetching videos: $e");
    } finally {
      videoloading = false;
      update();
    }
  }

  List<VideoModel> getVideosForSubject(String subjectId) {
    if (videos.isNotEmpty) {
      var listOfVideos =
          videos.where((element) => element.subjectId == subjectId).toList();
      return listOfVideos;
    } else {
      return [];
    }
  }
  List<VideoModel> getVideosById(String videoId) {
    if (videos.isNotEmpty) {
      var listOfVideos =
      videos.where((element) => element.videoId == videoId).toList();
      return listOfVideos;
    } else {
      return [];
    }
  }


  List<VideoModel> getRecommendedVideoForSubject(String subjectId) {
    if (videos.isNotEmpty) {
      var listOfVideos =
          videos.where((element) => (element.subjectId == subjectId) && (element.recommended ?? false)).toList();
      return listOfVideos;
    } else {
      return [];
    }
  }

  // sendVideoReview(VideoModel videoModel,int rating,String review) async {
  //   try{
  //     sendLoading = true;
  //     update();
  //     await FirebaseFirestore.instance
  //         .collection("completedVideos")
  //         .doc(videoModel.videoId)
  //         .set(
  //             CompletedVideosModel(
  //                     courseId: videoModel.courseId,
  //                     date: DateFormat("YYYY-MM-DD hh:mm:ss")
  //                         .format(DateTime.now()),
  //                     id: videoModel.videoId,
  //                     subjectId: videoModel.subjectId,
  //                     teacherId: videoModel.teacherId,
  //                     topicId: videoModel.topicId,
  //                     uid: authController.userData!.userId,
  //                     rating: rating,
  //                     review: review)
  //                 .toJson(),
  //             SetOptions(merge: true));
  //
  //
  //      var newRating = updateAverageRating((videoModel.ratings ?? 0).toDouble(), (videoModel.totalRating ?? 0).toInt(), rating);
  //
  //
  //
  //     await FirebaseFirestore.instance
  //         .collection("videos")
  //         .doc(videoModel.videoId)
  //         .set(
  //         videoModel.copyWith(totalRating:  videoModel.totalRating! + 1,ratings: newRating)
  //             .toJson(),
  //         SetOptions(merge: true));
  //
  //      getVideos();
  //
  //
  //     sendLoading = true;
  //     update();
  //     Get.snackbar("Success","Reveiw Submitted");
  //   }catch(e){
  //     sendLoading = false;
  //     update();
  //     Get.snackbar("Something went wrong","Please try again");
  //   }
  // }


  // Future<void> getAllCompletedVideos() async {
  //
  //   try {
  //     // Fetch data from Firestore
  //     QuerySnapshot querySnapshot =
  //     await FirebaseFirestore.instance.collection('completedVideos').where("uid",isEqualTo: authController.userData!.userId.toString()).get();
  //
  //     // Map Firestore data to Video model
  //     completedVideos = querySnapshot.docs
  //         .map((doc) => CompletedVideosModel.fromJson(doc.data() as Map<String, dynamic>))
  //         .toList();
  //
  //     // Cache the fetched videos
  //
  //     update();
  //   } catch (e) {
  //     print("Error fetching videos: $e");
  //   } finally {
  //
  //   }
  // }


  int updateAverageRating(double currentAverageRating, int totalCountOfRatings, int newRating) {
    // Calculate the new average rating
    double newAverageRating = ((currentAverageRating * totalCountOfRatings) + newRating) / (totalCountOfRatings + 1);
    return newAverageRating.round();
  }

  // Future<File> createFileOfPdfUrl(String urlString) async {
  //   pdfLoading = true;
  //   update();
  //   Completer<File> completer = Completer();
  //   print("Start download file from internet!");
  //   try {
  //     // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
  //     // final url = "https://pdfkit.org/docs/guide.pdf";
  //     final url = urlString;
  //         // "http://www.pdf995.com/samples/pdf.pdf";
  //     final filename = url.substring(url.lastIndexOf("/") + 1);
  //     var request = await HttpClient().getUrl(Uri.parse(url));
  //     var response = await request.close();
  //     var bytes = await consolidateHttpClientResponseBytes(response);
  //     var dir = await getApplicationDocumentsDirectory();
  //     print("Download files");
  //     print("${dir.path}/$filename");
  //     File file = File("${dir.path}/$filename");
  //
  //     await file.writeAsBytes(bytes, flush: true);
  //
  //     completer.complete(file);
  //   } catch (e) {
  //     throw Exception('Error parsing asset file!');
  //   }
  //   pdfLoading = false;
  //   update();
  //   return completer.future;
  // }




}
