import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:walk/src/constants/bluetoothconstants.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/devicecontroller.dart';
import 'package:walk/src/controllers/sharedpreferences.dart';
import 'package:walk/src/controllers/wificontroller.dart';

import 'package:walk/src/views/device/wifipage.dart';
import 'package:walk/src/widgets/circlebattstatus.dart';

class CommandPage extends StatefulWidget {
  const CommandPage({super.key});

  @override
  State<CommandPage> createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  bool isLoaded = false;
  double freqValue = 0.4;
  double magValue = 0;
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
          "Personalize WALK",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColor.appBarColor,
        actions: [
          Consumer2<DeviceController, WifiController>(
            builder: (context, deviceController, wifiController, child) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const WifiPage();
                      },
                    ),
                  );
                },
                icon: (wifiController.wifiVerificationStatus ||

                        ///This is done as two different controllers handle the wifi provisioned status , wificontroller and
                        ///devicecontroller so which ever says wifi provisioned is true we accept that
                        deviceController.wifiProvisionStatus)
                    ? const Icon(
                        Icons.verified,
                        size: 30,
                      )
                    : const Icon(
                        Icons.not_interested,
                        size: 30,
                      ),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xffF5F5F5),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Consumer<DeviceController>(builder: (context, controller, child) {
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
                    const Text(
                      "Battery Status",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isLoaded
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              circularProgressIndicator(controller.battS, "L",
                                  controller.batteryRemaining),
                              circularProgressIndicator(controller.battC, "R",
                                  controller.batteryRemaining),
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )
                  ],
                ),
              );
            }),
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
              //Frequency
              builder: (context, controller, child) => Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xfffafafa),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Frequency ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Slider(
                      value: freqValue,
                      min: 0.3,
                      max: 2,
                      label: freqValue.toString(),
                      thumbColor: Colors.purple,
                      onChanged: (value) {
                        HapticFeedback.lightImpact();
                        freqValue = value;
                        setState(() {});
                      },
                      onChangeEnd: (value) async {
                        String command = "$FREQ c $freqValue;";
                        await controller.sendToDevice(
                            command, WRITECHARACTERISTICS);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Consumer<DeviceController>(
              //Magnitude Widget
              builder: (context, controller, child) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Magnitude",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            letterSpacing: 1),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Slider(
                          value: magValue,
                          min: 0,
                          max: 4,
                          divisions: 4,
                          label: magValue.toString(),
                          thumbColor: Colors.purple,
                          onChanged: (value) {
                            HapticFeedback.lightImpact();
                            magValue = value;
                            setState(() {});
                          },
                          onChangeEnd: (value) async {
                            String command = "$MAG c $magValue;";
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
              //Mode Widget
              builder: (context, controller, child) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xfffafafa),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Mode",
                        style: TextStyle(
                            color: Colors.black,
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
                          thumbColor: Colors.purple,
                          onChanged: (value) {
                            HapticFeedback.lightImpact();
                            modeValue = value;
                            setState(() {});
                          },
                          onChangeEnd: (value) async {
                            String command = "$MODE $modeValue;";
                            await controller.sendToDevice(
                                command, WRITECHARACTERISTICS);
                          }),
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
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.all(20),
                          elevation: 6,
                        ),
                        onPressed: () async {
                          await controller.sendToDevice(
                              SOS, WRITECHARACTERISTICS);
                        },
                        child: const Text(
                          "SOS",
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
}
