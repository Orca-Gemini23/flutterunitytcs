import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart' as hive;
import 'package:walk/src/models/medication_model.dart';

/// Initializing Hive for local storage
Future<void> initializeLocalDatabase() async {
  try {
    await Hive.initFlutter();
    hive.Hive.registerAdapter(PrescriptionModelAdapter());
    hive.Hive.registerAdapter(MedicineModelAdapter());
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
  /// Opens new Box for every new medicine
  static Future<Box<MedicineModel>> openNewMedicineBox(String name) async =>
      await Hive.openBox<MedicineModel>(name);

  /// Instance of Hive box for storing prescriptions
  static Box<PrescriptionModel> medBox() =>
      Hive.box<PrescriptionModel>("medBox"); //static Box<PrescriptionModel>

  /// Get specific prescription by its ID
  static PrescriptionModel? get prescription =>
      medBox().get(prescription?.prescriptionId);

  /// Save specific prescription in local storage
  static savePrescription(PrescriptionModel prescription) {
    medBox().add(prescription);
  }

  /// Updates specific prescription in local storage
  static updatePrescription(int key, PrescriptionModel? prescription) {
    medBox().put(key, prescription!);
  }

  /// Deletes specific prescription from local storage
  static deletePrescription(int index) async {
    await medBox().deleteAt(index);
  }

  /// Listenable value for prescription Box
  static ValueListenable<Box<PrescriptionModel>> medS() =>
      medBox().listenable();

  //     /// Instance of Hive box for storing prescriptions
  // static Box<MedicineModel> medicine() =>
  //     Hive.box<MedicineModel>("medBox"); //static Box<PrescriptionModel>

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
