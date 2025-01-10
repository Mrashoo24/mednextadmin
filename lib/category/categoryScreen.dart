import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mednextadmin/Controller/categoryController.dart';
import 'package:mednextadmin/core/colors.dart';
import 'package:paged_datatable/paged_datatable.dart';

import 'categoryForm.dart';


class CategoriesScreen extends StatefulWidget {

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryController categoryController = Get.put<CategoryController>(CategoryController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories'),
       actions: [
          IconButton(
            icon: const Icon(Icons.add), // Trailing icon
            onPressed: () {
              // Define your action here
              Get.to(AddCategoryScreen());
              print('Trailing icon pressed');
            },
          ),
        ],

      ),
      body: GetBuilder<CategoryController>(
        builder: (controller) {
          return ListView.builder(
              itemCount: categoryController.categories.length,
              itemBuilder: (context,index){

                var cat = categoryController.categories[index];

            return Container(
              margin: EdgeInsets.symmetric(horizontal: Get.width*0.1,vertical: 10),
             // margin: EdgeInsets.all(5),
              height: 40,

           decoration: BoxDecoration(
             color: klightblue,
             boxShadow: [
               BoxShadow(
                 color: Colors.grey.withOpacity(0.5),
                 spreadRadius: 5,
                 blurRadius: 5,
               )
             ]
           ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(cat.name),
                  SizedBox(width: 150,),
                  GestureDetector(
                    onTap: () {
                      showConfirmationDialog(
                        context,
                        title: "Edit",
                        message: "Are you sure you want to edit?",
                        onConfirm: () {
                          // Add your edit logic here
                          print("Edit confirmed");
                          Get.to(AddCategoryScreen());
                        },
                      );
                    },
                    child: Icon(Icons.edit, size: 15),
                  ),
                 // SizedBox(width: 10,),
                  GestureDetector(
                    onTap: () {
                      showConfirmationDialog(
                        context,
                        title: "Delete",
                        message: "Are you sure you want to delete?",
                        onConfirm: () {
                          // Add your delete logic here
                          print("Delete confirmed");
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Icon(Icons.delete_forever, size: 15),
                  ),

                ],
              ),
            );
          });
        }
      )
      // Container(
      //   color: const Color.fromARGB(255, 208, 208, 208),
      //   padding: const EdgeInsets.all(20.0),
      //   child: Column(
      //     children: [
      //       // Expanded(
      //       //   child: PagedDataTableTheme(
      //       //     data: PagedDataTableThemeData(
      //       //       selectedRow: const Color(0xFFCE93D8),
      //       //       rowColor: (index) => index.isEven ? Colors.blue[50] : null,
      //       //     ),
      //       //     child: PagedDataTable<String, CategoryModel>(
      //       //       controller: tableController,
      //       //       // initialPage: 10,
      //       //       // pageS: const [10, 20, 50],
      //       //       // fetchPage: (pageSize, sortModel, filterModel, pageToken) async {
      //       //       //    categoryController.getCategories(
      //       //       //     pageSize: pageSize,
      //       //       //     pageToken: pageToken,
      //       //       //     sortBy: sortModel?.fieldName,
      //       //       //     sortDescending: sortModel?.descending ?? false,
      //       //       //     searchQuery: filterModel["name"],
      //       //       //   );
      //       //       //   return ([],1);
      //       //       // },
      //       //       columns: [
      //       //         RowSelectorColumn(),
      //       //         TableColumn(
      //       //           title: const Text("ID"),
      //       //           cellBuilder: (context, item, index) =>
      //       //               Text(item.id.toString()),
      //       //         ),
      //       //         TableColumn(
      //       //           title: const Text("Name"),
      //       //           cellBuilder: (context, item, index) => Text(item.name),
      //       //           sortable: true,
      //       //           id: "name",
      //       //         ),
      //       //         LargeTextTableColumn(
      //       //           title: const Text("Description"),
      //       //           getter: (item, index) => item.description,
      //       //           setter: (item, newValue, index) async {
      //       //             await Future.delayed(const Duration(seconds: 1));
      //       //             item.description = newValue;
      //       //             return true;
      //       //           },
      //       //         ),
      //       //         DropdownTableColumn(
      //       //           title: const Text("Enabled"),
      //       //           items: const <DropdownMenuItem<bool>>[
      //       //             DropdownMenuItem(value: true, child: Text("Yes")),
      //       //             DropdownMenuItem(value: false, child: Text("No")),
      //       //           ],
      //       //           getter: (item, index) => item.isEnabled,
      //       //           setter: (item, newValue, index) async {
      //       //             await Future.delayed(const Duration(seconds: 1));
      //       //             item.isEnabled = newValue;
      //       //             return true;
      //       //           },
      //       //         ),
      //       //       ], fetchPage: (pageToken, int pageSize, SortBy? sortBy, Filtering filtering) {  }, initialPage: 10, idGetter: (item) {  },
      //       //     ),
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }
}
void showConfirmationDialog(
    BuildContext context, {
      required String title,
      required String message,
      required VoidCallback onConfirm,
    }) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: onConfirm,
            child: Text("Confirm"),
          ),
        ],
      );
    },
  );
}
