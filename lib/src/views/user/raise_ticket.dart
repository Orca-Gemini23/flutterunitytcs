import "package:flutter/material.dart";
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        height: double.infinity,
        child: Column(
          children: [
            Image.asset(AppAssets.lifesparklogo),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 100,
              color: AppColor.greenDarkColor,
              child: const Center(
                child: Text(
                  "Describe us the issue you are facing ",
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
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///Todo: Elderly can't type so its better that we present them with a single button that will inform us about the issue faced by a customer
                  getTextfield(
                    "What is the topic of the issue",
                    problem_Title_Controller,
                    Icons.abc,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  getLargeTextField("Please describe the problem here",
                      problem_Description_Controller, Icons.note),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
