import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/wifi_enum.dart';
import 'package:walk/src/controllers/devicecontroller.dart';
import 'package:walk/src/controllers/sharedpreferences.dart';
import 'package:walk/src/controllers/wificontroller.dart';
import 'package:walk/src/utils/custom_navigation.dart';

import 'package:walk/src/views/device/wifipage.dart';
import 'package:walk/src/widgets/circlebattstatus.dart';

class CommandPage extends StatefulWidget {
  const CommandPage({super.key});

  @override
  State<CommandPage> createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  bool isLoaded = false;
  double modeValue = -1;

  ///Once the user reaches this page we assume that he already had used the connect button and also has clicked the tile. Therefore now we mark the status of isShowCaseDone as true, so that from next time user does not get the showcase
  setShowCaseStatus() async {
    await PreferenceController.saveboolData(showCaseKey, true);
  }

  @override
  void initState() {
    super.initState();
    setShowCaseStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppString.commandPageTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColor.appBarColor,
        actions: [
          Consumer2<DeviceController, WifiController>(
            builder: (context, deviceController, wifiController, child) {
              return ElevatedButton(
                onPressed: () {
                  if (wifiController.wifiVerificationStatus) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      btnOk: ElevatedButton(
                        onPressed: () async {
                          Go.to(context: context, push: const WifiPage());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.errorColor, elevation: 0),
                        child: const Text('Yes'),
                      ),
                      btnCancel: ElevatedButton(
                        onPressed: () {
                          Go.back(context: context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.greenColor, elevation: 0),
                        child: const Text('No'),
                      ),
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            AppString.wifiVerified,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColor.blackColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            AppString.wifiChange,
                            style: TextStyle(
                                color: AppColor.errorColor,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ).show();
                  } else {
                    Go.to(context: context, push: const WifiPage());
                  }
                },
                child: getWifiStatusIcons(deviceController.wifiProvisionStatus),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: AppColor.whiteColor,
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          shrinkWrap: true,
          children: [
            Consumer<DeviceController>(
              builder: (context, controller, child) {
                isLoaded = controller.batteryInfoStatus;
                return Container(
                  padding: const EdgeInsets.all(10),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            AppString.batteryStatus,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                //fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              await controller.getBatteryPercentageValues();
                              await controller.getBatteryRemaining();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.purpleColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 10,
                            ),
                            child: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isLoaded
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                circularProgressIndicator(controller.battS, "L",
                                    controller.serverBatteryRemaining),
                                circularProgressIndicator(controller.battC, "R",
                                    controller.clientBatteryRemaining),
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            const SizedBox(
              height: 5,
            ),
            Consumer<DeviceController>(
              //FREQUENCY WIDGET
              builder: (context, controller, child) => Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColor.black12,
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppString.frequency,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Consumer<DeviceController>(
                        builder: (context, deviceController, child) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.amberColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            deviceController.frequencyValue.toString().length >
                                    3
                                ? deviceController.frequencyValue
                                    .toString()
                                    .substring(0, 4)
                                : deviceController.frequencyValue.toString(),
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      child: Slider(
                        value: controller.frequencyValue,
                        min: 0.3,
                        max: 2,
                        label: controller.frequencyValue.toString(),
                        thumbColor: Colors.purple,
                        onChanged: (value) {
                          HapticFeedback.lightImpact();
                          controller.setfreqValue(value);
                        },
                        onChangeEnd: (value) async {
                          String approxFrequency =
                              controller.frequencyValue.toString().length > 3
                                  ? controller.frequencyValue
                                      .toString()
                                      .substring(0, 4)
                                  : controller.frequencyValue.toString();

                          String command = "$FREQ s $approxFrequency;";

                          log(command);
                          await controller.sendToDevice(
                              command, WRITECHARACTERISTICS);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Consumer<DeviceController>(
              //MAGNITUDE WIDGET
              builder: (context, controller, child) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.black12,
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppString.magnitude,
                        style: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 22,
                            letterSpacing: 1),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Consumer<DeviceController>(
                          builder: (context, deviceController, child) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColor.amberColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              deviceController.magValue.toString(),
                            ),
                          ),
                        );
                      }),
                      Slider(
                          //MAGNITUDE SLIDER
                          value: controller.magValue,
                          min: 0,
                          max: 4,
                          divisions: 4,
                          label: controller.magValue.toString(),
                          thumbColor: AppColor.purpleColor,
                          onChanged: (value) {
                            HapticFeedback.lightImpact();
                            controller.setmagValue(value);
                          },
                          onChangeEnd: (value) async {
                            String command = "$MAG s ${controller.magValue};";
                            log(command);
                            await controller.sendToDevice(
                                command, WRITECHARACTERISTICS);
                          }),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Consumer<DeviceController>(
              //MODE WIDGET
              builder: (context, controller, child) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.black12,
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AppString.mode,
                        style: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 22,
                            letterSpacing: 1),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Slider(
                        value: modeValue,
                        min: -1,
                        max: 7,
                        divisions: 8,
                        label: modeValue.toString(),
                        thumbColor: AppColor.purpleColor,
                        onChanged: (value) {
                          HapticFeedback.lightImpact();
                          modeValue = value;
                          setState(() {});
                        },
                        onChangeEnd: (value) async {
                          String command = "$MODE $modeValue;";
                          log(command);
                          await controller.sendToDevice(
                              command, WRITECHARACTERISTICS);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),

            Consumer<DeviceController>(
              builder: (context, controller, child) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColor.amberColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ...List.generate(
                      //   controller.buttonNames.length,
                      //   (index) {
                      //     List<Future> buttonFunction = [
                      //       controller.sendToDevice(SOS, WRITECHARACTERISTICS),
                      //       controller.sendToDevice(
                      //           RESTART, WRITECHARACTERISTICS),
                      //       controller.sendToDevice(RSTF, WRITECHARACTERISTICS),
                      //       controller.sendToDevice(
                      //           RPROV, WRITECHARACTERISTICS),
                      //     ];
                      //     return ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         shape: const CircleBorder(),
                      //         backgroundColor: AppColor.purpleColor,
                      //         padding: const EdgeInsets.all(20),
                      //         elevation: 6,
                      //       ),
                      //       onPressed: () async {
                      //         await buttonFunction[index];
                      //       },
                      //       child: Text(
                      //         controller.buttonNames[index],
                      //         style: const TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.all(20),
                          elevation: 6,
                        ),
                        onPressed: () async {
                          // SEND RESTART COMMAND
                          await controller.sendToDevice(
                              RESTART, WRITECHARACTERISTICS);
                        },
                        child: const Text(
                          "RES",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.all(20),
                          elevation: 6,
                        ),
                        onPressed: () async {
                          //SEND RESET TO FACTORY COMMAND
                          await controller.sendToDevice(
                              RSTF, WRITECHARACTERISTICS);
                        },
                        child: const Text(
                          "RSTF",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.all(20),
                          elevation: 6,
                        ),
                        onPressed: () async {
                          //SEND REMOVE ALL WIFI CREDENTIALS COMMAND

                          await controller.sendToDevice(
                              RPROV, WRITECHARACTERISTICS);
                        },
                        child: const Text(
                          "RPRV",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ) //Sos ,Restart , Rstf ,rprov   Container
          ],
        ),
      ),
    );
  }

  Widget getWifiStatusIcons(int status) {
    if (status == WifiStatus.NOTPROVISONED.index) {
      return const Icon(Icons.not_interested);
    }
    if (status == WifiStatus.PROVISIONED.index) {
      return const Icon(Icons.verified);
    } else {
      return const CircularProgressIndicator();
    }
  }
}
