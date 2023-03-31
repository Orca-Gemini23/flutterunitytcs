import 'package:flutter/material.dart';

loadingDialog(
  BuildContext context,
) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 76, 174, 255),
          borderRadius: BorderRadius.circular(40),
        ),
        height: 400,
        child: Center(
          child: Image.asset("assets/images/bleloading.gif"),
        ),
      ),
    ),
  );
}
