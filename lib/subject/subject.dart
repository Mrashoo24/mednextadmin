import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../common/dialog.dart';

class AddSubjectForm extends StatefulWidget {
  @override
  _AddSubjectFormState createState() => _AddSubjectFormState();
}

class _AddSubjectFormState extends State<AddSubjectForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _subjectNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // State Variables
  List<String> _selectedCourses = [];
  List<DropdownItem<String>> courseOptions = [];
  Uint8List? _logoFile;
  MultiSelectController<String> multiSelectController = MultiSelectController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> doc = [];

  @override
  void initState() {
    super.initState();
    _fetchCoursesFromFirebase();
  }

  // Fetch course IDs from Firebase
  Future<void> _fetchCoursesFromFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('course').get();



      multiSelectController.addItems(snapshot.docs.map((doc) {
        return DropdownItem<String>(
          value: doc.id,
          label: doc['name'], // Assuming each category has a 'name' field
        );
      }).toList()); /// Add  items to dropdown

      setState(() {

      });
    } catch (e) {
      print('Error fetching courses: $e');
    }
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

        final fileBytes = result.files.first.bytes;

        setState(() {
          switch (field) {
            case 'thumbnail':
              _logoFile = fileBytes;
              break;
            case 'video':
              // videoFile = fileBytes;

              break;
            case 'notes':
              // notesFile = fileBytes;
              break;
          }
        });

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

  // Save subject to Firebase
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _logoFile != null) {
      showLoadingDialog(context);

     var thumbnailUrl = await uploadFile(
        _logoFile!,
        'thumbnails/${DateTime.now().millisecondsSinceEpoch}',
        'jpg',
        ValueNotifier(0),
        0,
      );

      final subject = {
        'subjectName': _subjectNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'courseId': _selectedCourses,
        'logo': thumbnailUrl,
        "teachers" : [],
          "totalNotes" : 0,
        "totalQuestions" : 0,
        "totalStudents" : 0,
        "totalTestSeries" : 0,
        "totalVideos" : 0
      };

      try {
       var doc = await FirebaseFirestore.instance.collection('subjects').add(subject);


        await FirebaseFirestore.instance
            .collection('subjects')
            .doc(doc.id.toString())
            .update({"subjectId": doc.id.toString()});


        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Subject added successfully!')));
        _formKey.currentState!.reset();
        setState(() {
          _selectedCourses = [];
          _logoFile = null;
        });
       Navigator.pop(context);

      } catch (e) {
        Navigator.pop(context);

        print('Error adding subject: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add subject.')));
      }
    } else if (_logoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a logo image.')));
    }
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_courseOptions ${doc.length}");
    return Scaffold(
      appBar: AppBar(title: Text('Add Subject')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _subjectNameController,
                decoration: InputDecoration(labelText: 'Subject Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subject name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Select Courses:', style: TextStyle(fontWeight: FontWeight.bold)),
              MultiDropdown<String>(
                onSelectionChange: (selectedItems) {
                  setState(() {
                    _selectedCourses = selectedItems.map((e) => e).toList();
                  });
                },
                controller: multiSelectController,
                searchEnabled: true, items: const [],
                // selectedItems: _selectedCourses.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                // hint: 'Select courses',
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: (){
                      pickFile("thumbnail", false, "image");
                    },
                    child: Text('Pick Logo Image'),
                  ),
                  SizedBox(width: 10.0),
                  if (_logoFile != null) Text('Logo Selected', style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Subject'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
