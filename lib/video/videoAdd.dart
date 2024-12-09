import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:video_compress/video_compress.dart';

import '../common/elvatedButton.dart';

class AddVideoScreen extends StatefulWidget {
  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  String? selectedCourseId;
  String? selectedYearId;
  String? selectedSubjectId;
  String? selectedteacherId;
  String? selectedTopicId;
  Uint8List? thumbnailFile;
  Uint8List? videoFile;
  Uint8List? notesFile;
  List<Uint8List> slidesFiles = [];

  String? thumbnailUrl;
  String? videoUrl;
  String? notesPdfUrl;
  List<String> slidesUrls = [];

  bool isTopicCustom = false;
  TextEditingController customTopicController = TextEditingController();

  List<DropdownMenuItem<String>> courseItems = [];
  List<DropdownMenuItem<String>> teacherItems = [];
  List<DropdownMenuItem<String>> yearItem = [];
  List<DropdownMenuItem<String>> subjectItems = [];
  List<DropdownMenuItem<String>> topicItems = [];

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    final courses = await FirebaseFirestore.instance.collection('course').get();
    setState(() {
      courseItems = courses.docs
          .map((doc) => DropdownMenuItem(
        value: doc.id,
        child: Text(doc['name']),
      ))
          .toList();
    });
  }

  Future<void> loadYears(String courseId) async {
    final courses = await FirebaseFirestore.instance
        .collection('course')
        .where("id", isEqualTo: courseId)
        .get();
    setState(() {
      yearItem = List<String>.from(courses.docs.first.data()["questionOptions"])
          .map((doc) => DropdownMenuItem(
        value: doc,
        child: Text(doc),
      ))
          .toList();
    });
  }

  Future<void> loadSubjects(String courseId) async {
    final subjects = await FirebaseFirestore.instance
        .collection('subjects')
        .where('courseId', arrayContains: courseId)
        .get();
    setState(() {
      subjectItems = subjects.docs
          .map((doc) => DropdownMenuItem(
        value: doc.id,
        child: Text(doc['subjectName']),
      ))
          .toList();
    });
  }

  Future<void> loadTeachers(String subjectId) async {
    final subjects = await FirebaseFirestore.instance
        .collection('teachers')
        .where('registeredSubjects', arrayContains: subjectId)
        .get();
    setState(() {
      teacherItems = subjects.docs
          .map((doc) => DropdownMenuItem(
        value: doc.id,
        child: Text(doc['fullName']),
      ))
          .toList();
    });
  }

  Future<void> loadTopics(String subjectId) async {
    final topics = await FirebaseFirestore.instance
        .collection('topics')
        .where('subjectId', isEqualTo: subjectId)
        .get();
    setState(() {
      topicItems = topics.docs
          .map((doc) => DropdownMenuItem(
        value: doc.id,
        child: Text(doc['topicName']),
      ))
          .toList();
    });
  }


  Future<MediaInfo?> compressVideo(String path) async {
    return await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.MediumQuality, // Adjust quality level
      deleteOrigin: false, // Set to true if you want to delete the original file
    );
  }


  Future<void> pickFile(String field, bool isMultiple, String allowedType) async {
    FilePickerResult? result;
    result = await FilePicker.platform.pickFiles(
      allowMultiple: isMultiple,
      type: allowedType == 'image' ? FileType.image : allowedType == 'video' ? FileType.video : FileType.custom,
      allowedExtensions: allowedType == 'pdf' ? ['pdf'] : null,
      allowCompression: true,
      compressionQuality: 100
    );

    if (result != null) {
      if (isMultiple) {
        setState(() {
          slidesFiles = result!.files.map((file) => file.bytes!).toList();
        });
      } else {
        final fileBytes = result.files.first.bytes;

        setState(() {
          switch (field) {
            case 'thumbnail':
              thumbnailFile = fileBytes;
              break;
            case 'video':
              videoFile = fileBytes;

              break;
            case 'notes':
              notesFile = fileBytes;
              break;
          }
        });
      }
    }
  }

  Future<String?> uploadFile(
      Uint8List file,
      String path,
      String extension,
      ValueNotifier<double> totalProgress, // Pass total progress notifier
      int totalFiles, // Total number of files being uploaded
      ) async {
    try {
      String mimeType;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'mp4':
        case 'mov':
          mimeType = 'video/mp4';
          break;
        case 'pdf':
          mimeType = 'application/pdf';
          break;
        default:
          mimeType = 'application/octet-stream';
      }

      final ref = FirebaseStorage.instance.ref().child('$path.$extension');
      final uploadTask = ref.putData(
        file,
        SettableMetadata(contentType: mimeType),
      );

      uploadTask.snapshotEvents.listen((taskSnapshot) {
        if (taskSnapshot.state == TaskState.running) {
          double progress =
              taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;

          // Update the cumulative progress
          totalProgress.value += (progress / totalFiles);
        }
      });

      await uploadTask;
      return await ref.getDownloadURL();
    } catch (e) {
      print("File upload error: $e");
      return null;
    }
  }


  // Future<void> uploadVideo() async {
  //   // Pick a video file
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
  //
  //   if (result != null) {
  //     final fileBytes = result.files.single.bytes!;
  //     final fileName = result.files.single.name;
  //
  //     // Base64 encode the file bytes
  //     final base64File = base64Encode(fileBytes);
  //
  //     // Send the file to the Cloud Function
  //     final response = await http.post(
  //       Uri.parse('https://us-central1-zaika-pizza-hub.cloudfunctions.net/med-next-video-upload'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         'fileName': fileName,
  //         'fileBytes': base64File,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('File uploaded successfully');
  //     } else {
  //       print('Failed to upload file: ${response.body}');
  //     }
  //   }
  // }




  Future<void> saveVideo() async {



    if (_formKey.currentState!.validate()) {



      String topicId = isTopicCustom ? customTopicController.text : selectedTopicId ?? '';
      ValueNotifier<double> totalProgress = ValueNotifier<double>(0.0);
      int totalFiles = 2 + slidesFiles.length; // Thumbnail + Video + Notes + Slides

      showLoadingDialog(context,totalProgress);

      try {
        thumbnailUrl = await uploadFile(
          thumbnailFile!,
          'thumbnails/${DateTime.now().millisecondsSinceEpoch}',
          'jpg',
          totalProgress,
          totalFiles,
        );

        videoUrl = await uploadFile(
          videoFile!,
          'videos/${DateTime.now().millisecondsSinceEpoch}',
          'mp4',
          totalProgress,
          totalFiles,
        );

        notesPdfUrl = await uploadFile(
          notesFile!,
          'notes/${DateTime.now().millisecondsSinceEpoch}',
          'pdf',
          totalProgress,
          totalFiles,
        );

        for (var slide in slidesFiles) {
          String? url = await uploadFile(
            slide,
            'slides/${DateTime.now().millisecondsSinceEpoch}',
            'jpg',
            totalProgress,
            totalFiles,
          );
          if (url != null) slidesUrls.add(url);
        }

        var id = await FirebaseFirestore.instance.collection('videos').add({
          'courseId': selectedCourseId,
          'subjectId': selectedSubjectId,
          'topicId': topicId,
          'title': titleController.text,
          'description': descriptionController.text,
          'duration': int.parse(durationController.text),
          'thumbnail': thumbnailUrl,
          'url': videoUrl,
          'notes_pdf': notesPdfUrl,
          'slides': slidesUrls,
          'uploadDate': DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
          'paid': false,
          'recommended': false,
          "totalRating": 0,
          "ratings": 5,
          "teacherId": selectedteacherId
        });

        await FirebaseFirestore.instance
            .collection('videos')
            .doc(id.id.toString())
            .update({"videoId": id.toString()});

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Video added successfully")));
      } finally {
        dismissLoadingDialog(context);
        Navigator.pop(context); // Close the progress dialog
      }
    }
  }



  // Show loading dialog
  void showLoadingDialog(BuildContext context,ValueListenable<double> totalProgress) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents interaction
      builder: (context) {
        return Dialog(
          child:  ValueListenableBuilder<double>(
            valueListenable: totalProgress,
            builder: (context, progress, child) {
              return AlertDialog(
                title: Text("Uploading..."),
                content: LinearProgressIndicator(value: progress),
              );
            },
          ),
        );
      },
    );
  }

// Dismiss loading dialog
  void dismissLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Video")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3),
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Title"),
                      validator: (value) => value!.isEmpty ? "Please enter a title" : null,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: "Description"),
                      maxLines: 3,
                      validator: (value) => value!.isEmpty ? "Please enter a description" : null,
                    ),
                    TextFormField(
                      controller: durationController,
                      decoration: InputDecoration(labelText: "Duration (seconds)"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) => value!.isEmpty ? "Please enter duration" : null,
                    ),
                    DropdownButtonFormField(
                      value: selectedCourseId,
                      items: courseItems,
                      onChanged: (value) {
                        setState(() {
                          selectedCourseId = value as String?;
                          subjectItems = [];
                          yearItem = [];
                          selectedSubjectId = null;
                          selectedYearId = null;
                          loadYears(value as String);
                        });
                      },
                      decoration: InputDecoration(labelText: "Select Course"),
                    ),
                    DropdownButtonFormField(
                      value: selectedYearId,
                      items: yearItem,
                      onChanged: (value) {
                        setState(() {
                          selectedYearId = value as String?;
                          subjectItems = [];
                          selectedSubjectId = null;
                          loadSubjects(selectedCourseId.toString() + "/" + (value as String));
                        });
                      },
                      decoration: InputDecoration(labelText: "Select Year"),
                    ),
                    DropdownButtonFormField(
                      value: selectedSubjectId,
                      items: subjectItems,
                      onChanged: (value) {
                        setState(() {
                          selectedSubjectId = value;
                          topicItems = [];
                          selectedTopicId = null;
                          loadTopics(value as String);


                          teacherItems = [];
                          selectedteacherId = null;
                          loadTeachers(value as String);
                        });
                      },
                      decoration: InputDecoration(labelText: "Select Subject"),
                    ),
                    DropdownButtonFormField(
                      value: selectedteacherId,
                      items: teacherItems,
                      onChanged: (value) {
                        setState(() {
                          selectedteacherId = value;
                        });
                      },
                      decoration: InputDecoration(labelText: "Select Teacher"),
                    ),
                    DropdownButtonFormField(
                      value: selectedTopicId,
                      items: topicItems,
                      onChanged: (value) {
                        setState(() {
                          isTopicCustom = false;
                          selectedTopicId = value as String?;
                        });
                      },
                      decoration: InputDecoration(labelText: "Select Topic"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              thumbnailFile != null
                  ? Image.memory(thumbnailFile!, height: 100)
                  : Container(),
              SizedBox(height: 16),
              buildSaveButton("Select Thumbnail",
                      (){pickFile("thumbnail", false, "image");},context),
              videoFile != null
                  ? Text("Video selected")
                  : Container(),
              SizedBox(height: 16),
              buildSaveButton("Select Video",
                      () {pickFile("video", false, "video");},context),
              slidesFiles.isNotEmpty
                  ? Text("${slidesFiles.length} slide(s) selected")
                  : Container(),
              SizedBox(height: 16),
              buildSaveButton("Select Slides",
                      () {pickFile("slides", true, "image");},context),
              notesFile != null
                  ? Text("Notes selected")
                  : Container(),
              SizedBox(height: 16),
              buildSaveButton("Select Notes (PDF)",(){pickFile("notes", true, "pdf");},context),
              SizedBox(height: 16),
              buildSaveButton("Save Video", (){saveVideo();},context),

            ],
          ),
        ),
      ),
    );
  }

}
