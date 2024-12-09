
import 'package:flutter/material.dart';

Widget buildSaveButton(String title,void Function() funcction,BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3),
    child: ElevatedButton(
        onPressed: () {

          funcction();
        },

        child: Text(title,textAlign: TextAlign.center,)),
  );
}