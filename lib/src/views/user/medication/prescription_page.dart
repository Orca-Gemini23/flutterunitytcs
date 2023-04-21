import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/user_controller.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/medication_model.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/widgets/medication_card.dart';

class PrescriptionPage extends StatelessWidget {
  const PrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppString.medicationTitle,
          style: TextStyle(
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
        centerTitle: false,
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      body: ValueListenableBuilder<Box<PrescriptionModel>>(
          valueListenable: LocalDB.medS(),
          builder: (context, prescription, child) {
            return ListView.builder(
              itemCount: prescription.length,
              itemBuilder: (context, index) {
                var presc = prescription.values.toList().elementAt(index);
                return PrescriptionCard(
                  title: presc.prescriptionName,
                  doctor: presc.doctorName,
                  onDelete: () => userController.deletePrescription(index),
                  onTap: () =>
                      userController.prescriptionTileTap(context, presc, index),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showPrescriptionDialog(context, userController),
        backgroundColor: AppColor.greenDarkColor,
        child: const Icon(Icons.add, color: AppColor.whiteColor),
      ),
    );
  }

  /// Shows dialog for adding prescription
  Future<void> showPrescriptionDialog(
      BuildContext context, UserController userController) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        content: SizedBox(
          width: 150,

          // padding: const EdgeInsets.all(10.0),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(16.0),
          //   color: AppColor.whiteColor,
          // ),
          child: Form(
            key: userController.prescriptionFormKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Align(
                  child: TextFormField(
                    controller: userController.prescriptionNameController,
                    cursorColor: AppColor.greenDarkColor,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      } else {
                        return 'Field cannot be empty!';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Prescription Name',
                      hintText: 'Medication for what ailment or condition',
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
                const SizedBox(
                  height: 10,
                ),
                Align(
                  child: TextFormField(
                    controller: userController.prescriptionDoctorController,
                    cursorColor: AppColor.greenDarkColor,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      } else {
                        return 'Field cannot be empty!';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Doctor Name',
                      hintText: 'Prescribed by?',
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
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          userController.prescriptionNameController.clear();
                          userController.prescriptionDoctorController.clear();
                          Go.back(context: context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.whiteColor,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: AppColor.greenDarkColor),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            userController.addPrescription(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.greenDarkColor,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'OK',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
