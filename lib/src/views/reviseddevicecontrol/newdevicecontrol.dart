// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/additionalsettings/addsettings.dart';
import 'package:walk/src/views/reviseddevicecontrol/batterydetailscreen.dart';
import 'package:walk/src/widgets/devicecontrolpage/magnitudeslider.dart';
import 'package:walk/src/widgets/dialog.dart';

class DeviceControlPage extends StatefulWidget {
  const DeviceControlPage({super.key});

  @override
  State<DeviceControlPage> createState() => _DeviceControlPageState();
}

class _DeviceControlPageState extends State<DeviceControlPage>
    with WidgetsBindingObserver {
  bool sosMode = false;
  late DeviceController deviceController;
  StreamSubscription<BluetoothConnectionState>? _deviceStateSubscription;
  bool isDialogup = true;
  late Future<bool> metricsFuture;

  Future<bool> getDeviceMetrics() async {
    try {
      await deviceController.getBatteryPercentageValues();

      await deviceController.getFrequencyValues();

      await deviceController.getMagnitudeValues();

      return true;
    } catch (e) {
      // print(e);
      throw "Something went wrong , please try again ";
    }
  }

  @override
  void initState() {
    super.initState();
    deviceController = Provider.of<DeviceController>(context, listen: false);
    metricsFuture = getDeviceMetrics();
  }

  @override
  void dispose() {
    _deviceStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: const Text(
          "Device Control",
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings:
                      const RouteSettings(name: "/device/additionalsettings"),
                  builder: (context) => const AdditionalSettings(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings_outlined,
              size: 30,
            ),
          )
        ],
      ),
      body: StreamBuilder<BluetoothConnectionState>(
          stream: deviceController.connectedDevice?.connectionState ??
              const Stream.empty(),
          builder: (context, connectionSnapshot) {
            log("Stream output is ${connectionSnapshot.data} ");
            if (connectionSnapshot.data ==
                BluetoothConnectionState.disconnected) {
              if (isDialogup) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) {
                    setState(() {
                      isDialogup = false;
                    });
                    deviceController.clearConnectedDevice();

                    CustomDialogs.showBleDisconnectedDialog(context);
                  },
                );
              }
            }
            return FutureBuilder<bool>(
              builder: (context, deviceMetricSnapshot) {
                switch (deviceMetricSnapshot.connectionState) {
                  case ConnectionState.waiting:
                    {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.greenDarkColor,
                        ),
                      );
                    }
                  case ConnectionState.done:
                  default:
                    if (deviceMetricSnapshot.hasError) {
                      return const Center(
                        child: Text(
                            "Some error occurred getting device details. Try again."),
                      );
                    } else if (deviceMetricSnapshot.hasData) {
                      return Consumer<DeviceController>(
                        builder: (context, deviceController, widget) {
                          return Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            padding: const EdgeInsets.only(
                              bottom: 15,
                              left: 15,
                              right: 15,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: 120,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor.lightgreen),
                                    child: Row(
                                      children: [
                                        Text(
                                          "SOS",
                                          style: TextStyle(
                                            color: AppColor.blackColor,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        const Spacer(),
                                        Switch(
                                          activeColor: AppColor.greenDarkColor,
                                          activeTrackColor:
                                              AppColor.greenDarkColor,
                                          value: sosMode,
                                          onChanged: (value) async {
                                            sosMode = value;
                                            setState(() {});
                                            if (sosMode) {
                                              String modeCommand = "mode 4;";
                                              await deviceController
                                                  .sendToDevice(
                                                modeCommand,
                                                WRITECHARACTERISTICS,
                                              );
                                            } else {
                                              String modeCommand = "mode 4;";
                                              await deviceController
                                                  .sendToDevice(
                                                modeCommand,
                                                WRITECHARACTERISTICS,
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 180.h,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.lightbluegrey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Image(
                                        height: 119.h,
                                        width: 119.w,
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.fitHeight,
                                        image: const AssetImage(
                                          "assets/images/battery.png",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ////Implement Battery Refresh
                                          Go.to(
                                            context: context,
                                            push: const BatteryDetails(),
                                          );
                                        },
                                        onVerticalDragDown: (_) async {
                                          await deviceController
                                              .refreshBatteryValues();
                                        },
                                        child: Container(
                                          ////Left Battery Container
                                          width: 90.w,
                                          height: 135.h,

                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppColor.whiteColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                  offset: Offset(4, 4),
                                                  color: AppColor.black12,
                                                  blurRadius: 3,
                                                  spreadRadius: 1),
                                              BoxShadow(
                                                  offset: Offset(-4, 0),
                                                  color: AppColor.black12,
                                                  blurRadius: 5,
                                                  spreadRadius: 1)
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: double.maxFinite,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                                decoration: const BoxDecoration(
                                                  color: AppColor.lightgreen,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                child: Text(
                                                  "Left",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Visibility(
                                                replacement:
                                                    CircularPercentIndicator(
                                                  radius: 20.w,
                                                  backgroundColor:
                                                      AppColor.lightgreen,
                                                ),
                                                child: CircularPercentIndicator(
                                                  lineWidth: 7,
                                                  percent:
                                                      deviceController.battS /
                                                          100,
                                                  radius: 20.w,
                                                  center:
                                                      deviceController.battS <
                                                              30
                                                          ? const Icon(
                                                              Icons.error,
                                                              color: Colors.red,
                                                            )
                                                          : null,
                                                  progressColor:
                                                      deviceController.battS <
                                                              30
                                                          ? Colors.red
                                                          : AppColor
                                                              .greenDarkColor,
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${deviceController.battS}%",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                  letterSpacing: 1,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          Go.to(
                                              context: context,
                                              push: const BatteryDetails());
                                        },
                                        onVerticalDragDown: (details) async {
                                          await deviceController
                                              .refreshBatteryValues();
                                        },
                                        child: Container(
                                          ////Right Battery Container
                                          width: 90.w,
                                          height: 135.h,
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColor.whiteColor,
                                              boxShadow: const [
                                                BoxShadow(
                                                  offset: Offset(4, 4),
                                                  color: AppColor.black12,
                                                  blurRadius: 3,
                                                  spreadRadius: 1,
                                                ),
                                                BoxShadow(
                                                  offset: Offset(-4, 0),
                                                  color: AppColor.black12,
                                                  blurRadius: 5,
                                                  spreadRadius: 1,
                                                )
                                              ]),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: double.maxFinite,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                                decoration: const BoxDecoration(
                                                  color: AppColor.lightgreen,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                child: Text(
                                                  "Right",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              CircularPercentIndicator(
                                                lineWidth: 7,
                                                percent:
                                                    deviceController.battC /
                                                        100,
                                                radius: 20.w,
                                                center:
                                                    deviceController.battC < 30
                                                        ? const Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          )
                                                        : null,
                                                progressColor:
                                                    deviceController.battC < 30
                                                        ? Colors.red
                                                        : AppColor
                                                            .greenDarkColor,
                                                circularStrokeCap:
                                                    CircularStrokeCap.round,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${deviceController.battC}%",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  letterSpacing: 1,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.lightgreen,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColor.greyLight,
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          blurStyle: BlurStyle.normal,
                                        )
                                      ]),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  width: double.maxFinite,
                                  height: 107.h,
                                  child: Stack(
                                    textDirection: TextDirection.ltr,
                                    children: [
                                      Positioned(
                                        top: 0.h,
                                        child: Text(
                                          AppString.frequency,
                                          style: TextStyle(
                                            color: AppColor.blackColor,
                                            fontSize: 16.sp,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        top: 20.h,
                                        bottom: 0,
                                        child: SliderTheme(
                                          data: const SliderThemeData(
                                            trackHeight: 8,
                                            activeTrackColor:
                                                AppColor.greenDarkColor,
                                          ),
                                          child: Slider(
                                            value:
                                                deviceController.frequencyValue,
                                            min: 0.3,
                                            max: 2,
                                            label: deviceController
                                                .frequencyValue
                                                .toString(),
                                            thumbColor: AppColor.greenDarkColor,
                                            onChanged: (value) {
                                              HapticFeedback.lightImpact();
                                              deviceController
                                                  .setfreqValue(value);
                                            },
                                            onChangeEnd: (value) async {
                                              String approxFrequency =
                                                  deviceController
                                                              .frequencyValue
                                                              .toString()
                                                              .length >
                                                          3
                                                      ? deviceController
                                                          .frequencyValue
                                                          .toString()
                                                          .substring(0, 4)
                                                      : deviceController
                                                          .frequencyValue
                                                          .toString();

                                              String command =
                                                  "$FREQ c $approxFrequency;";

                                              log(command);
                                              await deviceController
                                                  .sendToDevice(command,
                                                      WRITECHARACTERISTICS);
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.lightgreen,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColor.greyLight,
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          blurStyle: BlurStyle.normal,
                                        )
                                      ]),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  width: double.maxFinite,
                                  height: 140.h,
                                  child: Stack(
                                    textDirection: TextDirection.ltr,
                                    children: [
                                      Positioned(
                                        child: Text(
                                          AppString.magnitude,
                                          style: TextStyle(
                                            color: AppColor.blackColor,
                                            fontSize: 16.sp,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: 40,
                                          left: 0,
                                          right: 0,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Left",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                  magSlider(
                                                      false, deviceController),
                                                ],
                                              ),
                                              // const Spacer(),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Right",
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  magSlider(
                                                      true, deviceController),
                                                ],
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      "App Connected",
                                      style: TextStyle(
                                        color: AppColor.greenDarkColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    const Spacer(),
                                    connectionSnapshot.data ==
                                            BluetoothConnectionState
                                                .disconnected
                                        ? const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.check_circle_outline_sharp,
                                          )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Divider(
                                  thickness: 4,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Both Bands Connected",
                                      style: TextStyle(
                                        color: AppColor.greenDarkColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    const Spacer(),
                                    connectionSnapshot.data ==
                                            BluetoothConnectionState
                                                .disconnected
                                        ? const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.check_circle_outline_sharp,
                                          )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text("No data by device");
                    }
                }
              },
              future: metricsFuture,
            );
          }),
    );
  }
}
