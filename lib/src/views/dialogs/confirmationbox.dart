import 'package:flutter/material.dart';
import 'package:walk/src/utils/global_variables.dart';

class ConfirmationBox extends StatelessWidget {
  final String title;
  final String content;
  final String btnText;
  final VoidCallback onConfirm;

  const ConfirmationBox(
      {super.key,
      required this.title,
      required this.content,
      required this.onConfirm,
      required this.btnText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: DeviceSize.isTablet
          ? const EdgeInsets.fromLTRB(48, 40, 48, 48)
          : null,
      title: Text(
        title,
        style: TextStyle(fontSize: DeviceSize.isTablet ? 40 : null),
      ),
      content: Text(
        content,
        style: TextStyle(fontSize: DeviceSize.isTablet ? 24 : null),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onConfirm(); // Perform the action passed to the widget
            Navigator.of(context).pop(); // Close the dialog after action
          },
          child: Text('Yes',
              style: TextStyle(
                  fontSize: DeviceSize.isTablet ? 24 : null,
                  color: Colors.black)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Closes the dialog without action
          },
          child: Text('No',
              style: TextStyle(
                color: const Color(0xFF005749),
                fontWeight: FontWeight.bold,
                fontSize: DeviceSize.isTablet ? 24 : null,
              )),
        ),
      ],
    );
  }
}
