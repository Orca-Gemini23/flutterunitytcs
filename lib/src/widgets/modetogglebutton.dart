import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';

class ActiveInactiveButtons extends StatefulWidget {
  const ActiveInactiveButtons({super.key});

  @override
  State<ActiveInactiveButtons> createState() => _ActiveInactiveButtonsState();
}

class _ActiveInactiveButtonsState extends State<ActiveInactiveButtons> {
  int _activeButtonIndex = 0; // To keep track of the active button index

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          // border: Border.all(width: 1, color: AppColor.greenDarkColor),
          color: AppColor.lightgreen,
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 1, // 50% of available width
                child: _buildButton(0, "Burst"),
              ),
            ),
            const SizedBox(width: 10), // Add some spacing between buttons
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 1, // 50% of available width
                child: _buildButton(1, "Continuous"),
              ),
            ),
          ],
        ));
  }

  // Method to build individual buttons
  Widget _buildButton(int index, String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _activeButtonIndex = index; // Update active button when clicked
        });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 50), // Set standard width to 70
        backgroundColor: _activeButtonIndex == index
            ? const Color(0xFF005749)
            : Colors.transparent, // Active button has green background
        elevation: 0, // Remove elevation
        shadowColor: Colors.transparent,
        // side: _activeButtonIndex == index ? null :BorderSide(
        //   color: Color(0xFF005749), // Green border for inactive buttons
        //   width: 2.0,
        // ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Border radius of 5
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _activeButtonIndex == index ? Colors.white : const Color(0xFF005749),
        ),
      ),
    );
  }
}
