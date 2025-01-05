import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mednextadmin/Controller/categoryController.dart';
import 'package:paged_datatable/paged_datatable.dart';


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
      appBar: AppBar(title: const Text('Categories')),
      body: Column(
        children: [
          Text("List Of Categories"),
          Expanded(
            child: GetBuilder<CategoryController>(
              builder: (controller) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: categoryController.categories.length,
                    itemBuilder: (context,index){

                      var cat = categoryController.categories[index];

                  return Container(
                    child: Card(
                      child: Text(cat.name),
                    ),
                  );
                });
              }
            ),
          )
        ],
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
