import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents interaction
    builder: (context) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        child:  AlertDialog(
          backgroundColor: Colors.transparent,
          title: Text("Please wait..."),
        ),
      );
    },
  );
}
