// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/user/personal_info.dart';

class UserController extends ChangeNotifier {
  UserController() {
    medicineTextController = [
      medNameController,
      medDescController,
      medAmountController,
      medTypeController
    ];
  }

  Map<String, String> userDemographicInf = {};

  /// Currently opened prescription

  /// Prescription Index also its ID from Hive box
  int prescriptionIndex = -1;

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

  /// List of medicine controller
  List<TextEditingController> medicineTextController = [];

  /// Medication Time during a day (morning/afternoon/evening/night)
  int medTiming = 0;
  // List<int> medTimings = [0, 1, 2, 3];
  Map<String, bool> medTimings = {
    'Morning': false,
    'Afternoon': false,
    'Evening': false,
    'Night': false
  };

  /// Medication before or after food
  int afterFood = 0;

  /// Medication Duration (for how many days)
  DateTime medicationDuration = DateTime.now();

  /// showDialog Global Form key for prescription
  final prescriptionFormKey = GlobalKey<FormState>();

  /// showDialog Global Form key for Medication Page
  final medicineFormKey = GlobalKey<FormState>();

  /// List of prescriptions

  /// List of Medicines

  /// Creates new prescription reminder
  Future<void> addPrescription(BuildContext context) async {
    try {
      if (prescriptionFormKey.currentState!.validate()) {
        // generates unique id for prescription
        dynamic uniqueID = UniqueKey();
        log('Unique prescription ID: $uniqueID');

        // saving prescription in local storage


        // closes showDialog
        Go.back(context: context);

        // clears the specified fields
        prescriptionNameController.clear();
        prescriptionDoctorController.clear();
      } else {
        log('Field EMPTY!');
      }

      notifyListeners();
    } catch (e) {
      log('Adding prescription error: $e');
    }
  }

  /// Deletes prescription from local storage
  void deletePrescription(int index, String medicineBoxName) async {
    try {

      notifyListeners();
    } catch (e) {
      log('Deleting prescription from storage error: $e');
    }
  }


  /// Deletes medicine from local storage
  void deleteMedicine(int index) async {
    try {

      notifyListeners();
    } catch (e) {
      log('Deleting prescription from storage error: $e');
    }
  }

  void onMedTimingSwitch(int value) {
    medTiming = value;
    notifyListeners();
  }

  void onAfterFood(int value) {
    afterFood = value;
    notifyListeners();
  }

  /// Account main screen navigation switch case
  void accountNavigation(int index, BuildContext context) {
    try {
      switch (index) {
        case 0:
          Go.to(context: context, push: const ProfilePage());
          break;

      }
    } catch (e) {
      log('help Nav function error: $e');
    }
  }

  /// Text label for Medicine page's add medicine method
  List<String> medicineTextEditingLabel = [
    'Name',
    'Description',
    'Medicine Amount',
    'Medicine Type'
  ];

  /// List of navigation in Account page
  Map<String, String> accountNavigationTile = {
    'Profile': 'Personal Information',
    'Medication Reminder': 'Create your own reminder for medications.',
    'Take a Quiz': 'Help us calibrate your device, for you personally.',
  };

  /// List of Time duration in a day
  List<String> dayTimings = ['Morning', 'Afternoon', 'Evening', 'Dinner'];

  /// Tile Icon Data for account page
  List<IconData> accountTileIcon = [Icons.person, Icons.medication, Icons.quiz];

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
