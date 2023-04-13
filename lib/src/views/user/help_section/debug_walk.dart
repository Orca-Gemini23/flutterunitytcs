import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/utils/custom_navigation.dart';

class DebugWalkPage extends StatelessWidget {
  const DebugWalkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Debugging WALK device..',
          style: TextStyle(
            color: AppColor.greenDarkColor,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => Go.back(context: context),
          icon: const Icon(Icons.arrow_back),
          color: AppColor.blackColor,
        ),
        elevation: 0,
        backgroundColor: AppColor.whiteColor,
      ),
      body: ListView(),
    );
  }
}
