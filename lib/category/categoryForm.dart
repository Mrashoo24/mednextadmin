import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../common/dialog.dart';
import '../common/elvatedButton.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryDescriptionController = TextEditingController();

  Uint8List? categoryImage;
  String? categoryImageUrl;

  // Method to pick an image for the category
  Future<void> pickCategoryImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
      compressionQuality: 100,
    );

    if (result != null) {
      final fileBytes = result.files.first.bytes;
      setState(() {
        categoryImage = fileBytes;
      });
    }
  }

  // // Method to upload category image to Firebase Storage
  // Future<String?> uploadCategoryImage(Uint8List file) async {
  //   try {
  //     final ref = FirebaseStorage.instance
  //         .ref()
  //         .child('categories/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //     final uploadTask = ref.putData(file);
  //
  //     await uploadTask;
  //     return await ref.getDownloadURL();
  //   } catch (e) {
  //     print("Error uploading image: $e");
  //     return null;
  //   }
  // }

  // Save the category to Firestore
  Future<void> saveCategory() async {
    if (_formKey.currentState!.validate()) {
      // if (categoryImage != null) {
      //   categoryImageUrl = await uploadCategoryImage(categoryImage!);
      // }
      showLoadingDialog(context);
      try {
       var doc = await FirebaseFirestore.instance.collection('categories').add({
          'name': categoryNameController.text,
          // 'categoryDescription': categoryDescriptionController.text,
          // 'categoryImage': categoryImageUrl,
        });
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(doc.id.toString())
            .update({"id": doc.id.toString()});


        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Category added successfully"),
        ));
      } catch (e) {
        print("Error saving category: $e");
      } finally {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
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
                      controller: categoryNameController,
                      decoration: InputDecoration(labelText: "Category Name"),
                      validator: (value) =>
                      value!.isEmpty ? "Please enter a category name" : null,
                    ),
                  ],
                ),
              ),
              // TextFormField(
              //   controller: categoryDescriptionController,
              //   decoration: InputDecoration(labelText: "Category Description"),
              //   maxLines: 3,
              //   validator: (value) =>
              //   value!.isEmpty ? "Please enter a category description" : null,
              // ),
              // SizedBox(height: 20),
              // GestureDetector(
              //   onTap: pickCategoryImage,
              //   child: categoryImage == null
              //       ? Container(
              //     height: 200,
              //     width: double.infinity,
              //     color: Colors.grey[200],
              //     child: Center(child: Text("Pick Image")),
              //   )
              //       : Image.memory(categoryImage!),
              // ),
              SizedBox(height: 20),

              buildSaveButton("Save Category", (){saveCategory();},context),

            ],
          ),
        ),
      ),
    );
  }
}
