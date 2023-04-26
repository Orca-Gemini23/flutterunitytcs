import 'package:hive/hive.dart';
part 'medication_model.g.dart';

@HiveType(typeId: 0)
class PrescriptionModel extends HiveObject {
  PrescriptionModel({
    required this.prescriptionId,
    required this.prescriptionName,
    required this.doctorName,
    this.medicineModel,
  });

  @HiveField(0)
  String prescriptionId;

  @HiveField(1)
  String prescriptionName;

  @HiveField(2)
  String doctorName;

  @HiveField(3)
  Box<MedicineModel>? medicineModel;
}

@HiveType(typeId: 1)
class MedicineModel extends HiveObject {
  MedicineModel({
    required this.medicineId,
    required this.medicineName,
    required this.medicineDesc,
    required this.medicineAmount,
    required this.medicineType,
    required this.medicineTiming,
    required this.afterFood,
    required this.medicineDuration,
  });

  @HiveField(0)
  String medicineId;

  @HiveField(1)
  String medicineName;

  @HiveField(2)
  String medicineDesc;

  @HiveField(3)
  String medicineAmount;

  @HiveField(4)
  String medicineType;

  @HiveField(5)
  int medicineTiming;

  @HiveField(6)
  int afterFood;

  @HiveField(7)
  DateTime medicineDuration;
}
