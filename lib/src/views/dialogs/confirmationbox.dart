import 'package:flutter/material.dart';

class ConfirmationBox extends StatelessWidget {
  final String title;
  final String content;
  final String btnText;
  final VoidCallback onConfirm;

  const ConfirmationBox({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.btnText
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            onConfirm(); // Perform the action passed to the widget
            Navigator.of(context).pop(); // Close the dialog after action
          },
          child: const Text('Yes', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Closes the dialog without action
          },
          child: const Text('No', style: TextStyle(color: Color(0xFF005749), fontWeight: FontWeight.bold)),
          
        ),
      ],
    );
  }
}
