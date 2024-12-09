import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../data/models/categorymodel.dart';
import '../data/models/coursemodel.dart';
import '../data/models/subjectModel.dart';
import '../data/models/topicModel.dart';
import '../data/models/usermodel.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[];
  var courses = <CourseModel>[];
  var subjects = <SubjectModel>[];
  var teachers = <UserModel>[];
  var topics = <TopicModel>[];

  var loading = false;
  var courseloading = false;

  var selectedCourseId = "";
  var selectedQQuestionId = "";

  SubjectModel? selectedSubject ;
  UserModel? selectedTeacher ;


  @override
  void onInit() {
    super.onInit();
  }

  // Load data from cache
  Future<void> loadCachedData() async {

        await getCategories();

        await  getCourse();



        await   getSubjects();



        await  getTopic();

        await getTeachersByCourse();
        update();

  }




  // Fetch categories with caching logic
  Future<void> getCategories() async {
    // if (categories.isNotEmpty) {
    //   return; // Skip fetch if data is already cached
    // }

    if(categories.isEmpty){
      loading = true;
      update();
    }

    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').get();

      // Map Firestore data to Category model
      categories = querySnapshot.docs.map((doc) => CategoryModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
      // Cache the fetched categories
      // box.write('categories', categories.map((category) => category.toJson()).toList());

      update();
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      loading = false;
      update();
    }
  }

  // Fetch courses with caching logic
  Future<void> getCourse() async {
    // if (courses.isNotEmpty) {
    //   return; // Skip fetch if data is already cached
    // }

    if(courses.isEmpty){
      courseloading = true;
      update();
    }
    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('course').get();

      // Map Firestore data to Course model
      courses = querySnapshot.docs.map((doc) => CourseModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

      // Cache the fetched courses
      // box.write('courses', courses.map((course) => course.toJson()).toList());

      update();
    } catch (e) {
      print("Error fetching courses: $e");
    } finally {
      courseloading = false;
      update();
    }
  }

  // Fetch subjects with caching logic
  Future<void> getSubjects() async {
    // if (subjects.isNotEmpty) {
    //   return; // Skip fetch if data is already cached
    // }

    if(subjects.isEmpty){
      courseloading = true;
      update();
    }
    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('subjects').get();

      // Map Firestore data to Subject model
      subjects = querySnapshot.docs.map((doc) => SubjectModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

      // Cache the fetched subjects
      // box.write('subjects', subjects.map((subject) => subject.toJson()).toList());

      update();
    } catch (e) {
      print("Error fetching subjects: $e");
    } finally {
      courseloading = false;
      update();
    }
  }

  // List<SubjectModel> getSubjectsByCourse()  {
  //    if (subjects.isNotEmpty) {
  //      return subjects.where((element) {
  //        var userCourse = authController.userData?.registeredCourses;
  //
  //        return element.courseIds!.contains(userCourse!.first);
  //
  //
  //      }).toList();
  //
  //    }else{
  //      return [];
  //    }
  //
  // }

  List<SubjectModel> getSubjectsByCourseId(String? courseId)  {
    if (subjects.isNotEmpty) {
      return subjects.where((element) {

        return element.courseIds!.contains(courseId);


      }).toList();

    }else{
      return [];
    }

  }

  SubjectModel? getSubjectsById(String id)  {
    if (subjects.isNotEmpty) {
      return subjects.firstWhere((element) {

        return element.subjectId! == id;


      });

    }else{
      return null;
    }

  }


  // Fetch subjects with caching logic
  Future<void> getTopic() async {
    // if (subjects.isNotEmpty) {
    //   return; // Skip fetch if data is already cached
    // }

    if(topics.isEmpty){
      courseloading = true;
      update();
    }
    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('topics').get();

      // Map Firestore data to Subject model
      topics = querySnapshot.docs.map((doc) => TopicModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

      // Cache the fetched subjects
      // box.write('topics', topics.map((subject) => subject.toJson()).toList());

      update();
    } catch (e) {
      print("Error fetching subjects: $e");
    } finally {
      courseloading = false;
      update();
    }
  }

  TopicModel? getTopicById(String id)  {
    if (topics.isNotEmpty) {
      return topics.firstWhere((element) {

        return element.id! == id;


      });

    }else{
      return null;
    }

  }

  List<TopicModel> getTopicBySubject(String subjectId)  {
    if (topics.isNotEmpty) {
      return topics.where((element) {

        return element.subjectId == (subjectId);


      }).toList();

    }else{
      return [];
    }

  }



  Future<void> getTeachersByCourse() async {

    // var year = authController.userData!.registeredCourses!;

    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('teachers').get();

      // Map Firestore data to Course model
      teachers = querySnapshot.docs.map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

      // teachers = teachers.where((element) => element.registeredCourses!.contains(year.first)).toList();

      update();
    } catch (e) {
      print("Error fetching courses: $e");
    }
  }


  List<UserModel> getTeachersBySubject(String subjectId)  {
    if (teachers.isNotEmpty) {
      return teachers.where((element) {

        return element.registeredSubjects!.contains(subjectId);


      }).toList();

    }else{
      return [];
    }

  }

  UserModel? getTeacherById(String teacherId)  {
    if (teachers.isNotEmpty) {
      return teachers.firstWhere((element) {

        return element.userId! == teacherId;


      });

    }else{
      return null;
    }

  }


}
