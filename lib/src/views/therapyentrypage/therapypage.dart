import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/widgets/therapybutton/balltherapysessionbutton.dart';
import 'package:walk/src/widgets/therapybutton/fishtherapysessionbutton.dart';
import 'package:walk/src/widgets/therapybutton/swingtherapysessionbutton.dart';

import '../../constants/bt_constants.dart';
import '../../controllers/device_controller.dart';

class TherapyEntryPage extends StatefulWidget {
  const TherapyEntryPage({super.key});

  @override
  State<TherapyEntryPage> createState() => _TherapyEntryPageState();
}

class _TherapyEntryPageState extends State<TherapyEntryPage> {
  var mode = 4;
  late DeviceController deviceController;

  @override
  void initState() {
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Therapy Entry Page')
        .then(
          (value) => debugPrint("Analytics stated"),
        );
    super.initState();
    deviceController = Provider.of<DeviceController>(context, listen: false);

    mode = deviceController.modeValue;
    deviceController.sendToDevice("mode 9;", WRITECHARACTERISTICS);
  }

  @override
  void dispose() {
    super.dispose();
    deviceController.sendToDevice("mode $mode;", WRITECHARACTERISTICS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        // title: const Text(
        //   "Therapy Session",
        //   style: TextStyle(
        //     color: AppColor.blackColor,
        //     fontSize: 16,
        //   ),
        // ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(
          top: 28,
          left: 15,
          right: 15,
          bottom: 15,
        ),
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
        ),
        child: const SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ////Device Control and AI therapy session control buttons
                  BallTherapySessionBtn(),
                  SwingTherapySessionBtn(),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FishTherapySessionBtn(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
