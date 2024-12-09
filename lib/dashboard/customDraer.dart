import 'package:flutter/material.dart';
import 'package:mednextadmin/core/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    print('rebuild custom drawer');
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                // Image.asset(
                //   'asset/logo1.png',
                //   width: 130,
                // ),
                SizedBox(height: 30),
                const Text(
                  'MY INCONN',
                  style: TextStyle(color: Colors.white),
                ),
                const Divider(
                  color: Colors.black45,
                ),
              ],
            ),
          ),

          DrawerTile(
            title: 'Category',
            icn: Icons.safety_check, onTap: () {

          },
          ),

          ///
          DrawerTile(
            title: 'Courses',
            icn: Icons.safety_check, onTap: () {

          },
          ),

          ///
          DrawerTile(
            title: 'Subjects',
            icn: Icons.safety_check, onTap: () {

          },
          ),

          ///
          DrawerTile(
            title: 'Topics',
            icn: Icons.safety_check, onTap: () {

          },
          ),

          DrawerTile(
            title: 'Teachers',
            icn: Icons.safety_check, onTap: () {

          },
          ),

          DrawerTile(
            title: 'Video',
            icn: Icons.safety_check, onTap: () {

          },
          ),
        ],
      ),
    );
  }
}

class DrawerTile extends StatefulWidget {
  String title;
  IconData icn;
  String route;
  void Function() onTap ;

  List<DrawerTile>? subOptions;
  DrawerTile({
    required this.title,
    required this.icn,
    this.subOptions,
    this.route = '',required this.onTap
  });

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  bool showChildren = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          if (widget.subOptions != null) {
            setState(() {
              showChildren = !showChildren;
            });
          } else {
            widget.onTap();
            // context.go(widget.route);
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 20, top: 35, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icn,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      FittedBox(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.subOptions != null)
                    showChildren
                        ? const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 20,
                          )
                        : const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.white,
                            size: 20,
                          ),
                ],
              ),
              if (widget.subOptions != null && showChildren)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.subOptions!.length,
                  itemBuilder: (ctx, i) {
                    return widget.subOptions![i];
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
