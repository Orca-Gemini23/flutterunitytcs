import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/user_controller.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/medication_model.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/widgets/medication_card.dart';

class MedicationPage extends StatelessWidget {
  const MedicationPage({super.key, required this.medPageTitle});
  final String medPageTitle;
  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          medPageTitle,
          style: const TextStyle(
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.blackColor,
            ),
            onPressed: (() {
              var l = LocalDB.medicinesList('[#d65af]'); //[#d65af]
              log(l.length.toString());
            }),
          ),
        ],
        centerTitle: false,
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      body: ValueListenableBuilder<Box<MedicineModel>>(
          valueListenable: LocalDB.listenableMedicine(
              userController.currentPrescription!.prescriptionId),
          builder: (context, medicine, child) {
            return ListView.builder(
              itemCount: medicine.length,
              itemBuilder: (context, index) {
                var meds = medicine.values.toList().elementAt(index);
                return MedicineCard(
                  title: meds.medicineName,
                  subtitle: meds.medicineAmount,
                  // onDelete: () => userController.deletePrescription(index),
                  // onTap: () =>
                  //     userController.prescriptionTileTap(context, presc, index),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addMedicine(context, userController),
        backgroundColor: AppColor.greenDarkColor,
        child: const Icon(Icons.add, color: AppColor.whiteColor),
      ),
    );
  }

  Future<void> addMedicine(
      BuildContext context, UserController userController) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0), topLeft: Radius.circular(16.0)),
      ),
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 10),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(16.0),
        //   color: AppColor.whiteColor,
        // ),
        child: Form(
          key: userController.medicineFormKey,
          child: Stack(
            children: [
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 50),
                shrinkWrap: true,
                children: <Widget>[
                  const SizedBox(
                    height: 16,
                  ),
                  ...List.generate(
                    userController.medicineTextController.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller:
                            userController.medicineTextController[index],
                        cursorColor: AppColor.greenDarkColor,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          } else {
                            return 'Field cannot be empty!';
                          }
                        },
                        decoration: InputDecoration(
                          labelText:
                              userController.medicineTextEditingLabel[index],
                          focusColor: AppColor.greenDarkColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: Screen.width(context: context) - 20,
                    child: Consumer<UserController>(
                      builder: (context, controller, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                AnimatedToggleSwitch<int>.rolling(
                                  current: controller.medTiming,
                                  values: controller.medTimings,
                                  borderColor: AppColor.greenDarkColor,
                                  indicatorColor: AppColor.greenDarkColor,
                                  onChanged: controller.onMedTimingSwitch,
                                  customIconBuilder: (context, local, global) {
                                    var ic = [
                                      Icons.cloud,
                                      Icons.sunny,
                                      Icons.cloudy_snowing,
                                      Icons.nightlight_round,
                                    ];
                                    return Icon(
                                      ic[local.index],
                                      color: local.value == controller.medTiming
                                          ? AppColor.whiteColor
                                          : AppColor.blackColor,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  userController
                                      .dayTimings[userController.medTiming],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.greenDarkColor),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                AnimatedToggleSwitch.dual(
                                  current: controller.afterFood,
                                  first: 0,
                                  second: 1,
                                  borderColor: AppColor.greenDarkColor,
                                  height: 45,
                                  indicatorColor: AppColor.greenDarkColor,
                                  textBuilder: (value) => Text(
                                    value == 0 ? 'Before Food' : 'After Food',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.greenDarkColor,
                                    ),
                                  ),
                                  onChanged: userController.onAfterFood,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: const BoxDecoration(
                  color: AppColor.greenDarkColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0),
                  ),
                ),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Medicine Details",
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => userController.addMedicine(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.whiteColor,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'ADD',
                        style: TextStyle(
                          color: AppColor.greenDarkColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
