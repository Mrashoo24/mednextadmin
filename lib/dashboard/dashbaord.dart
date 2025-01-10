import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mednextadmin/Controller/dashbaordController.dart';
import 'package:mednextadmin/topic/topic.dart';
import 'package:sidebar_drawer/sidebar_drawer.dart';

import '../Controller/categoryController.dart';
import '../adminscreens/coursescreenadmin.dart';
import '../adminscreens/subjectscreenadmin.dart';
import '../adminscreens/teacherscreenadmin.dart';
import '../adminscreens/topicscreenadmin.dart';
import '../adminscreens/videoscreenadmin.dart';
import '../category/categoryScreen.dart';
import 'customDraer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  var listOfWidgets = [
    CategoriesScreen(),
    CourseScreenadmin(),
    Subjectscreenadmin(),
    TopicScreenAdmin(),
    TeacherSCreenAdmin(),
    VideoScreenAdmin(),

  ];

  @override
  void initState() {
    final CategoryController categoryController = Get.put<CategoryController>(CategoryController());
    categoryController.loadCachedData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SidebarDrawer(
      drawer: CustomDrawer(),
      body: Scaffold(
        appBar:   AppBar(
          leading: DrawerIcon(),
        ),

        body: GetBuilder<DashboardController>(
            init: Get.put(DashboardController()),
            builder: (controller) {
              return listOfWidgets[controller.selectedIndex];
            }
        ),
      ),
    );
  }
}
