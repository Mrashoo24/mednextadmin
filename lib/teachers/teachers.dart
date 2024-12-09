import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mednextadmin/teachers/usermodel.dart';

import '../common/dialog.dart';

class AddTeacherScreen extends StatefulWidget {
  @override
  _AddTeacherScreenState createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController =
      TextEditingController(); // Only if you need to use a password
  String? selectedCity;
  String? selectedState;
  String? selectedCourse;
  String? selectedYear;

  String? selectedSubject;

  List<String> states = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
    "Delhi",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli and Daman and Diu",
    "Lakshadweep",
    "Puducherry"
  ];
  List<String> cities = [];
  List<DropdownMenuItem<String>> courseItems = [];
  List<DropdownMenuItem<String>> subjectItems = [];
  List<DropdownMenuItem<String>> listOfYears = [];

  Map<String, List<String>> courseYears = {};

  @override
  void initState() {
    super.initState();
    loadCourses(); // Load courses when the screen is initialized
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

      courses.docs.forEach((element) {

       courseYears.addAll({
         element.id.toString() : List<String>.from(element.data()["questionOptions"])
       });

      });

    });
  }

  Future<void> loadSubjects(String courseId) async {
    final subjects = await FirebaseFirestore.instance
        .collection('subjects')
        .where("courseId", arrayContains: courseId)
        .get();
    setState(() {
      subjectItems = subjects.docs.map((doc) {
        return DropdownMenuItem<String>(
          value: doc.id,
          child: Text(
              doc['subjectName']), // Assuming each category has a 'name' field
        );
      }).toList();
    });
  }

  void onStateChange(String? value) {
    setState(() {
      selectedState = value;
      selectedCity = null;

      // Logic to fetch values based on the selected city
      // This is an example and should be replaced with real data
      if (value == "Andhra Pradesh") {
        cities = [
          "Visakhapatnam",
          "Vijayawada",
          "Tirupati",
          "Guntur",
          "Kakinada"
        ];
      } else if (value == "Arunachal Pradesh") {
        cities = ["Itanagar", "Tawang", "Pasighat"];
      } else if (value == "Assam") {
        cities = ["Guwahati", "Dibrugarh", "Silchar", "Jorhat", "Nagaon"];
      } else if (value == "Bihar") {
        cities = ["Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Darbhanga"];
      } else if (value == "Chhattisgarh") {
        cities = ["Raipur", "Bilaspur", "Durg", "Korba", "Raigarh"];
      } else if (value == "Goa") {
        cities = ["Panaji", "Margao", "Vasco da Gama", "Mapusa"];
      } else if (value == "Gujarat") {
        cities = ["Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar"];
      } else if (value == "Haryana") {
        cities = ["Faridabad", "Gurugram", "Ambala", "Hisar", "Karnal"];
      } else if (value == "Himachal Pradesh") {
        cities = ["Shimla", "Manali", "Kullu", "Dharamshala"];
      } else if (value == "Jharkhand") {
        cities = ["Ranchi", "Jamshedpur", "Dhanbad", "Bokaro", "Giridih"];
      } else if (value == "Karnataka") {
        cities = ["Bangalore", "Mysuru", "Hubli", "Mangalore", "Belgaum"];
      } else if (value == "Kerala") {
        cities = [
          "Kochi",
          "Thiruvananthapuram",
          "Kozhikode",
          "Kollam",
          "Alappuzha"
        ];
      } else if (value == "Madhya Pradesh") {
        cities = ["Indore", "Bhopal", "Gwalior", "Jabalpur", "Ujjain"];
      } else if (value == "Maharashtra") {
        cities = ["Mumbai", "Pune", "Nagpur", "Thane", "Nashik"];
      } else if (value == "Manipur") {
        cities = ["Imphal"];
      } else if (value == "Meghalaya") {
        cities = ["Shillong", "Tura", "Jowai"];
      } else if (value == "Mizoram") {
        cities = ["Aizawl"];
      } else if (value == "Nagaland") {
        cities = ["Kohima", "Dimapur"];
      } else if (value == "Odisha") {
        cities = [
          "Bhubaneswar",
          "Cuttack",
          "Berhampur",
          "Rourkela",
          "Balasore"
        ];
      } else if (value == "Punjab") {
        cities = ["Chandigarh", "Amritsar", "Ludhiana", "Jalandhar", "Patiala"];
      } else if (value == "Rajasthan") {
        cities = ["Jaipur", "Udaipur", "Jodhpur", "Kota", "Ajmer"];
      } else if (value == "Sikkim") {
        cities = ["Gangtok"];
      } else if (value == "Tamil Nadu") {
        cities = [
          "Chennai",
          "Coimbatore",
          "Madurai",
          "Tiruchirappalli",
          "Salem"
        ];
      } else if (value == "Telangana") {
        cities = ["Hyderabad", "Warangal", "Khammam", "Nizamabad"];
      } else if (value == "Tripura") {
        cities = ["Agartala"];
      } else if (value == "Uttar Pradesh") {
        cities = ["Lucknow", "Kanpur", "Agra", "Ghaziabad", "Meerut"];
      } else if (value == "Uttarakhand") {
        cities = ["Dehradun", "Haridwar", "Nainital", "Rishikesh"];
      } else if (value == "West Bengal") {
        cities = ["Kolkata", "Howrah", "Durgapur", "Siliguri", "Asansol"];
      } else if (value == "Delhi") {
        cities = ["Delhi"];
      } else if (value == "Andaman and Nicobar Islands") {
        cities = ["Port Blair"];
      } else if (value == "Chandigarh") {
        cities = ["Chandigarh"];
      } else if (value == "Dadra and Nagar Haveli and Daman and Diu") {
        cities = ["Daman", "Silvassa"];
      } else if (value == "Lakshadweep") {
        cities = ["Kavaratti"];
      } else if (value == "Puducherry") {
        cities = ["Puducherry", "Karikal", "Mahe", "Yanam"];
      } else {
        cities = [];
      }

    });
  }

  void onCourseChanged(String? value) {
    setState(() {
      selectedCourse = value;

      if (value != null) {
        selectedYear = null;
        listOfYears = courseYears[value]!.map((e) => DropdownMenuItem<String>(
          value: e,
          child: Text(e), // Assuming each category has a 'name' field
        )).toList();

      } else {
        listOfYears = [];
        selectedYear = null;
      }
    });
  }

  void onYearChanged(String? value) {
    setState(() {
      selectedYear = value;

      if (value != null) {
        loadSubjects("$selectedCourse/$value");
      } else {
        subjectItems = [];
        selectedSubject = null;
      }
    });
  }

  Future<void> saveTeacher() async {
    if (_formKey.currentState!.validate()) {
      showLoadingDialog(context);

      final teacher = UserModel(
        fullName: fullNameController.text,
        email: emailController.text,
        password: passwordController
            .text, // If you want to store passwords, consider hashing
        city: selectedCity,
        state: selectedState,
        registeredCourses: [selectedCourse!],
        registeredSubjects: [selectedSubject!],
        // Add additional fields as necessary
      );

      // Add teacher to Firestore
    var doc =  await FirebaseFirestore.instance
          .collection('teachers')
          .add(teacher.toJson());

      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(doc.id.toString())
          .update({"userId": doc.id.toString()});

     var subjectDoc = await FirebaseFirestore.instance
          .collection('subjects')
          .doc(selectedSubject).get();

    var teachersList = List<String>.from(subjectDoc.data()?["teachers"]);

     teachersList.add(doc.id.toString());

       await FirebaseFirestore.instance
          .collection('subjects')
          .doc(selectedSubject).update({"teachers": teachersList});

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Teacher added successfully")));
      Navigator.pop(context); // Close the form
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Teacher")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a full name" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter an email" : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true, // Hide password
                validator: (value) =>
                    value!.isEmpty ? "Please enter a password" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedState,
                items: states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: onStateChange,
                decoration: InputDecoration(labelText: "State"),
                validator: (value) =>
                    value == null ? "Please select a state" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedCity,
                items: cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
                decoration: InputDecoration(labelText: "City"),
                validator: (value) =>
                    value == null ? "Please select a city" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedCourse,
                items: courseItems,
                onChanged: onCourseChanged,
                decoration: InputDecoration(labelText: "Select Course"),
                validator: (value) =>
                    value == null ? "Please select a course" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedYear,
                items: listOfYears,
                onChanged: onYearChanged,
                decoration: InputDecoration(labelText: "Select Year"),
                validator: (value) =>
                    value == null ? "Please select year" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedSubject,
                items: subjectItems,
                onChanged: (value) {
                  setState(() {
                    selectedSubject = value;
                  });
                },
                decoration: InputDecoration(labelText: "Select Subject"),
                validator: (value) =>
                    value == null ? "Please select a subject" : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: saveTeacher,
                child: Text("Save Teacher"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
