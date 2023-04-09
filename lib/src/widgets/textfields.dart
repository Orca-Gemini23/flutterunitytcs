import 'package:flutter/material.dart';

Widget getTextfield(
    String labelText, TextEditingController controller, IconData icon) {
  return Flexible(
    child: TextField(
      controller: controller,
      cursorColor: const Color(0xff005749),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff005749),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff005749),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 0,
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          icon,
          size: 30,
          color: Colors.grey,
        ),
      ),
    ),
  );
}

Widget getLargeTextField(
  String labelText,
  TextEditingController controller,
  IconData icon,
) {
  return Flexible(
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      cursorColor: const Color(0xff005749),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff005749),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff005749),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 0,
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          icon,
          size: 30,
          color: Colors.grey,
        ),
      ),
    ),
  );
}
