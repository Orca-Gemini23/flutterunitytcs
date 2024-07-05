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
  var mode = 0;
  late DeviceController deviceController;

  @override
  void initState() {
    super.initState();
    deviceController = Provider.of<DeviceController>(context, listen: false);

    mode = deviceController.modeValue;
    deviceController.sendToDevice("mode 9;", WRITECHARACTERISTICS);
  }

  @override
  void dispose() {
    super.dispose();
    deviceController.sendToDevice("mode 4;", WRITECHARACTERISTICS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: const Text(
          "Therapy Session",
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(
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
              SizedBox(height: 20),
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
