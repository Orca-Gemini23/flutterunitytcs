import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/user/medication/medication_page.dart';
import 'package:walk/src/views/user/medication/prescription_page.dart';
import 'package:walk/src/views/user/personal_info.dart';
import 'package:walk/src/views/user/quiz_section/quiz_page.dart';

class UserController extends ChangeNotifier {
  /// adding prescriptionLoader
  bool addPrescriptionLoader = false;

  /// Prescription Name
  TextEditingController prescriptionNameController = TextEditingController();

  /// Prescription description if any
  TextEditingController prescriptionDescController = TextEditingController();

  /// Prescription doctor
  TextEditingController prescriptionDoctorController = TextEditingController();

  /// Medication name
  TextEditingController medNameController = TextEditingController();

  /// Medication desc if any
  TextEditingController medDescController = TextEditingController();

  /// Medication amount
  TextEditingController medAmountController = TextEditingController();

  /// Medication Type (Capsule/syrup etc)
  TextEditingController medTypeController = TextEditingController();

  /// Medication Time during a day (morning/afternoon/evening/night)
  int medTiming = -1;

  /// Medication before or after food
  bool afterFood = false;

  /// Medication Duration (for how many days)
  DateTime medicationDuration = DateTime.now();

  /// showDialog Global Form key for prescription
  final _prescriptionFormKey = GlobalKey<FormState>();

  /// showDialog Global Form key for Medication Page
  final medicineFormKey = GlobalKey<FormState>();

  /// Creates new prescription reminder
  Future<void> addPrescription(BuildContext context) async {
    try {
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
              key: _prescriptionFormKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Align(
                    child: TextFormField(
                      controller: prescriptionNameController,
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
                      controller: prescriptionDoctorController,
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
                            prescriptionNameController.clear();
                            prescriptionDoctorController.clear();
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
                          onPressed: () {
                            if (_prescriptionFormKey.currentState!.validate()) {
                              Go.to(
                                  context: context,
                                  push: const MedicationPage());
                            } else {
                              log('Field EMPTY!');
                            }
                          },
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
      notifyListeners();
    } catch (e) {
      log('Adding prescription error: $e');
    }
  }

  /// Account main screen navigation switch case
  void accountNavigation(int index, BuildContext context) {
    try {
      switch (index) {
        case 0:
          Go.to(context: context, push: const ProfilePage());

          break;

        case 1:
          Go.to(context: context, push: const PrescriptionPage());

          break;
        case 2:
          Go.to(context: context, push: const QuizPage());

          break;
        default:
      }
    } catch (e) {
      log('help Nav function error: $e');
    }
  }

  /// List of navigation in Account page
  Map<String, String> accountNavigationTile = {
    'Profle': 'Personal Information',
    'Medication Reminder': 'Create your own reminder for medications.',
    'Take a Quiz': 'Help us calibrate your device, for you personally.',
  };

  @override
  void dispose() {
    prescriptionNameController.dispose();
    prescriptionDescController.dispose();
    prescriptionDoctorController.dispose();
    medNameController.dispose();
    medAmountController.dispose();
    medDescController.dispose();
    medTypeController.dispose();

    super.dispose();
  }
}
