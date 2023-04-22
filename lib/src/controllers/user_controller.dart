import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/medication_model.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/user/medication/medication_page.dart';
import 'package:walk/src/views/user/medication/prescription_page.dart';
import 'package:walk/src/views/user/personal_info.dart';
import 'package:walk/src/views/user/quiz_section/quiz_page.dart';

class UserController extends ChangeNotifier {
  UserController() {
    medicineTextController = [
      medNameController,
      medDescController,
      medAmountController,
      medTypeController
    ];
  }

  /// Currently opened prescription
  PrescriptionModel? currentPrescription;

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
  List<PrescriptionModel> prescriptionList = [];

  /// List of Medicines
  List<MedicineModel> medicineList = [];

  /// Creates new prescription reminder
  Future<void> addPrescription(BuildContext context) async {
    try {
      if (prescriptionFormKey.currentState!.validate()) {
        // generates unique id for prescription
        dynamic uniqueID = UniqueKey();
        log('Unique prescription ID: $uniqueID');

        // saving prescription in local storage
        LocalDB.savePrescription(PrescriptionModel(
          prescriptionId: uniqueID.toString(),
          prescriptionName: prescriptionNameController.text,
          doctorName: prescriptionDoctorController.text,
        ));

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
      await LocalDB.deletePrescription(index);
      await LocalDB.deleteMedicineBox(medicineBoxName);
      notifyListeners();
    } catch (e) {
      log('Deleting prescription from storage error: $e');
    }
  }

  /// Prescription tile on Tap method
  void prescriptionTileTap(BuildContext context, PrescriptionModel prescription,
      int presIndex) async {
    try {
      await LocalDB.openNewMedicineBox(prescription.prescriptionId);

      prescriptionIndex = presIndex;
      currentPrescription = prescription;
      Go.to(
          context: context,
          push: MedicationPage(
            prescriptionModel: prescription,
          ));
      notifyListeners();
    } catch (e) {
      log('prescription tile on tap error: $e');
    }
  }

  /// Adds Medicine in the prescription
  void addMedicine(BuildContext context) async {
    try {
      if (currentPrescription != null) {
        var medicineBox =
            LocalDB.medicineBox(currentPrescription!.prescriptionId);

        var medicine = MedicineModel(
          medicineId: '',
          medicineName: medNameController.text,
          medicineDesc: medDescController.text,
          medicineAmount: medAmountController.text,
          medicineType: medTypeController.text,
          medicineTiming: medTiming,
          afterFood: afterFood,
          medicineDuration: DateTime.now(),
        );
        LocalDB.saveMedicine(medicineBox, medicine);
        // currentPrescription!.medicineModel = newMedicineBox;
        // // updating prescription with medicine in local storage
        // LocalDB.updatePrescription(prescriptionIndex, currentPrescription);
        log('success?');
      }
    } catch (e) {
      log('Add medicine error: $e');
    }
  }

  /// Deletes medicine from local storage
  void deleteMedicine(int index) async {
    try {
      var medicineBox =
          LocalDB.medicineBox(currentPrescription!.prescriptionId);
      await LocalDB.deleteMedicine(medicineBox, index);
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

  /// Text label for Medicine page's add medicine method
  List<String> medicineTextEditingLabel = [
    'Name',
    'Description',
    'Medicine Amount',
    'Medicine Type'
  ];

  /// List of navigation in Account page
  Map<String, String> accountNavigationTile = {
    'Profle': 'Personal Information',
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
