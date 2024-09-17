import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart' as hive;
import 'package:walk/src/models/medication_model.dart';
import 'package:walk/src/models/user_model.dart';

/// Initializing Hive for local storage
Future<void> initializeLocalDatabase() async {
  try {
    await Hive.initFlutter();
    hive.Hive.registerAdapter(PrescriptionModelAdapter());
    hive.Hive.registerAdapter(MedicineModelAdapter());
    hive.Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<UserModel>('userBox');
    await Hive.openBox<PrescriptionModel>('medBox');
  } catch (e) {
    log('error initializing local database: $e');
  }
}

/// Closing hive and all its boxes
Future<void> disposeHiveBox() async {
  try {
    await Hive.close();
  } catch (e) {
    log('error disposing/closing local database: $e');
  }
}

class LocalDB {
  /// Instance of Hive box for storing prescriptions
  static UserModel defaultUser = UserModel(
    name: "Unknown User",
    age: "XX",
    phone: "",
    image: "NA",
    gender: "X",
    address: "x",
    email: "x",
  );

  static Box<PrescriptionModel> prescriptionBox() =>
      Hive.box<PrescriptionModel>("medBox"); //static Box<PrescriptionModel>

  static Box<UserModel> userBox() => Hive.box<UserModel>("userBox");
  static UserModel? get user => userBox().get(0, defaultValue: defaultUser);
  static saveUser(UserModel newUser) {
    userBox().put(0, newUser);
  }

  static ValueListenable<Box<UserModel>> listenableUser() =>
      userBox().listenable();

  /// Get specific prescription by its ID
  static PrescriptionModel? get prescription =>
      prescriptionBox().get(prescription?.prescriptionId);

  /// Save specific prescription in local storage
  static savePrescription(PrescriptionModel prescription) {
    prescriptionBox().add(prescription);
  }

  /// Updates specific prescription in local storage
  static updatePrescription(int key, PrescriptionModel? prescription) {
    prescriptionBox().put(key, prescription!);
  }

  /// Deletes specific prescription from local storage
  static deletePrescription(int index) async {
    await prescriptionBox().deleteAt(index);
  }

  /// Listenable value for prescription Box
  static ValueListenable<Box<PrescriptionModel>> listenablePrescription() =>
      prescriptionBox().listenable();

  /// Opens new Box for every new medicine
  static Future<Box<MedicineModel>> openNewMedicineBox(String name) async =>
      await Hive.openBox<MedicineModel>(name);

  /// Instance of Hive box for storing medicine
  static Box<MedicineModel> medicineBox(String name) =>
      Hive.box<MedicineModel>(name); //static Box<PrescriptionModel>

  /// Get specific prescription by its ID
  // static MedicineModel? get medicineID =>
  //     medBox().get(medicine!.medicineId);

  /// Save medicine in local storage
  static saveMedicine(Box<MedicineModel> medicineBox, MedicineModel medicine) {
    medicineBox.add(medicine);
  }

  /// Updates medicine in local storage
  static updateMedicine(
      Box<MedicineModel> medicineBox, int key, MedicineModel medicine) async {
    await medicineBox.put(key, medicine);
  }

  /// Deletes medicine from local storage
  static deleteMedicine(Box<MedicineModel> medicineBox, int index) async {
    await medicineBox.deleteAt(index);
  }

  /// Deletes All the medicine in the specific prescription from local storage
  static deleteMedicineBox(String name) async {
    var medicineBox = Hive.box<MedicineModel>(name);
    await medicineBox.deleteFromDisk();
  }

  /// Listenable value for medicine Box
  static ValueListenable<Box<MedicineModel>> listenableMedicine(String name) {
    var medicineBox = Hive.box<MedicineModel>(name);
    return medicineBox.listenable();
  }

  static List<MedicineModel> medicinesList(String name) {
    var medicineBox = Hive.box<MedicineModel>(name);
    return medicineBox.values.toList();
  }
}
