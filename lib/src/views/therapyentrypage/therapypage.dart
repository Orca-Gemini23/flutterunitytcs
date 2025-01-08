import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/db/firebase_storage.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/widgets/therapybutton/theraphysessionbuttons.dart';

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
        .logScreenView(screenName: 'Therapy Entry Page')
        .then(
          (value) => debugPrint("Analytics stated"),
        );
    super.initState();
    deviceController = Provider.of<DeviceController>(context, listen: false);
    deviceController.getDeviceMode().then((_) {
      mode = deviceController.modeValue;
    });
    deviceController.sendToDevice("mode 9;", WRITECHARACTERISTICS);
  }

  @override
  void dispose() {
    super.dispose();
    FirebaseStorageDB.putData();
    // FilePathChange.getExternalFiles();
    // UploadData().loadFiles();
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
          icon: Icon(
            Icons.arrow_back_ios,
            size: DeviceSize.isTablet ? 48 : 24,
          ),
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: DeviceSize.isTablet
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.spaceBetween,
                children: const [
                  ////Device Control and AI therapy session control buttons
                  TherapySessionButton(
                    imageAssetPath: "assets/images/ball.png",
                    unityScreenNumber: 0,
                    gameName: 'Ball Game',
                  ),
                  TherapySessionButton(
                    imageAssetPath: "assets/images/swing.png",
                    unityScreenNumber: 2,
                    gameName: 'Swing Game',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: DeviceSize.isTablet
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.spaceBetween,
                children: [
                  const TherapySessionButton(
                    imageAssetPath: "assets/images/fish.png",
                    unityScreenNumber: 1,
                    gameName: 'Fish Game',
                  ),
                  // // const FishTherapySessionBtn(),
                  if (DeviceSize.isTablet)
                    SizedBox(
                      height: 170.h,
                      width: 144.w,
                    )
                  // TaxiTherapySessionBtn(),
                ],
              ),
              // SizedBox(height: 24),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     AnglesDisplayBtn(),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
