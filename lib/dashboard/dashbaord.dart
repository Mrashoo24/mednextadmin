import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mednextadmin/Controller/dashbaordController.dart';
import 'package:mednextadmin/topic/topic.dart';
import 'package:sidebar_drawer/sidebar_drawer.dart';

import '../Controller/categoryController.dart';
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
    CategoriesScreen(),
    CategoriesScreen(),
    CategoriesScreen(),
    CategoriesScreen(),
    CategoriesScreen(),

  ];

  @override
  void initState() {
    final CategoryController categoryController = Get.put<CategoryController>(CategoryController());
    categoryController.loadCachedData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body:  SidebarDrawer(
        drawer: CustomDrawer(),

        body: GetBuilder<DashboardController>(
          init: Get.put(DashboardController()),
          builder: (controller) {
            return Column(
              children: [
                AppBar(
                  leading: DrawerIcon(),
                ),
                Container(
                    height: 300,
                    child: listOfWidgets[controller.selectedIndex]),
              ],
            );
          }
        ),
      ),
    );
  }
}
