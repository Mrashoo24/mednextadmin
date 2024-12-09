import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/models/updatesModel.dart';

class UpdatesController extends GetxController{

List<UpdatesModel> listOfUpdates = [];

Future<void> getUpdates() async {

  try {
    // Fetch data from Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('updates').get();

    // Map Firestore data to Subject model
    listOfUpdates = querySnapshot.docs.map((doc) => UpdatesModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    update();
  } catch (e) {
    print("Error fetching subjects: $e");
  } finally {
    update();
  }
}



}