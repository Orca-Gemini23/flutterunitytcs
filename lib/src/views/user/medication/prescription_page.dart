import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/user_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';

class PrescriptionPage extends StatelessWidget {
  const PrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppString.medicationTitle,
          style: TextStyle(
            color: AppColor.greenDarkColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.blackColor,
          ),
          onPressed: (() {
            Go.back(context: context);
          }),
        ),
        centerTitle: false,
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      body: ListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => userController.addPrescription(context),
        backgroundColor: AppColor.greenDarkColor,
        child: const Icon(Icons.add, color: AppColor.whiteColor),
      ),
    );
  }
}
