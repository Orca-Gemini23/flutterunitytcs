import 'dart:developer';

import "package:flutter/material.dart";
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/widgets/dropdown.dart';
import 'package:walk/src/widgets/textfields.dart';

class RaiseTicketPage extends StatefulWidget {
  const RaiseTicketPage({super.key});

  @override
  State<RaiseTicketPage> createState() => _RaiseTicketPageState();
}

class _RaiseTicketPageState extends State<RaiseTicketPage> {
  TextEditingController problem_Description_Controller =
      TextEditingController();

  TextEditingController problem_Title_Controller = TextEditingController();
  String defaultStringDropdown = "Device is not vibrating .";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          AppString.hereToHelp,
          style: TextStyle(
            color: AppColor.greenDarkColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
          color: AppColor.blackColor,
        ),
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.lifesparklogo),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              color: AppColor.greenDarkColor,
              child: const Center(
                child: Text(
                  "Select the issues you are facing from the dropdown ",
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColor.greenDarkColor,
              ),
              width: double.infinity,
              child: const Text(
                "Device related issues :",
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 16,
                ),
              ),
            ),
            const Expanded(
              child: SingleChildScrollView(
                child: MultiSelect(
                  items: [
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "other",
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColor.greenDarkColor,
              ),
              width: double.infinity,
              child: const Text(
                "User related issues :",
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 16,
                ),
              ),
            ),
            const Expanded(
              child: SingleChildScrollView(
                child: MultiSelect(
                  items: [
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "Helllpoooooo",
                    "other"
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: AppColor.greenDarkColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: AppColor.greenDarkColor),
                onPressed: () {},
                child: const Text(
                  "Raise Ticket",
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
