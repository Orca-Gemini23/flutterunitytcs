import 'dart:developer';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/help_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/widgets/dropdown.dart';
import 'package:walk/src/widgets/textfields.dart';

class RaiseTicketPage extends StatefulWidget {
  const RaiseTicketPage({super.key});

  @override
  State<RaiseTicketPage> createState() => _RaiseTicketPageState();
}

class _RaiseTicketPageState extends State<RaiseTicketPage> {
  // TextEditingController problem_Description_Controller =
  //     TextEditingController();

  // TextEditingController problem_Title_Controller = TextEditingController();
  String defaultStringDropdown = "Device is not vibrating .";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          AppString.raiseTicket,
          style: TextStyle(
            color: AppColor.greenDarkColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Go.back(context: context),
          icon: const Icon(Icons.arrow_back),
          color: AppColor.blackColor,
        ),
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset(AppAssets.lifesparklogo),
            const SizedBox(
              height: 10,
            ),

            const SizedBox(
              height: 10,
            ),

            Consumer<HelpController>(builder: (context, helpController, child) {
              return ExpansionPanelList(
                expansionCallback: helpController.onExpansionCallBack,
                children: helpController.ticketQueryQuestion
                    .map<ExpansionPanel>(
                      (item) => ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: item.isExpanded,
                        headerBuilder: (context, isExpanded) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColor.greenDarkColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                item.title,
                                style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                        body: MultiSelect(
                          items: List.generate(
                            5,
                            (index) => 'Query $index',
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            }),

            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
        child: FloatingActionButton.extended(
          onPressed: null,
          label: const Text(
            "Raise Ticket",
            style: TextStyle(
              color: AppColor.whiteColor,
            ),
          ),
          backgroundColor: AppColor.greenDarkColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
