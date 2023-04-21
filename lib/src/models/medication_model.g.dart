// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionModelAdapter extends TypeAdapter<PrescriptionModel> {
  @override
  final int typeId = 0;

  @override
  PrescriptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionModel(
      prescriptionId: fields[0] as String,
      prescriptionName: fields[1] as String,
      doctorName: fields[2] as String,
      medicineModel: fields[3] as Box<MedicineModel>?,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.prescriptionId)
      ..writeByte(1)
      ..write(obj.prescriptionName)
      ..writeByte(2)
      ..write(obj.doctorName)
      ..writeByte(3)
      ..write(obj.medicineModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicineModelAdapter extends TypeAdapter<MedicineModel> {
  @override
  final int typeId = 1;

  @override
  MedicineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineModel(
      medicineId: fields[0] as String,
      medicineName: fields[1] as String,
      medicineDesc: fields[2] as String,
      medicineAmount: fields[3] as String,
      medicineType: fields[4] as String,
      medicineTiming: fields[5] as int,
      afterFood: fields[6] as int,
      medicineDuration: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.medicineId)
      ..writeByte(1)
      ..write(obj.medicineName)
      ..writeByte(2)
      ..write(obj.medicineDesc)
      ..writeByte(3)
      ..write(obj.medicineAmount)
      ..writeByte(4)
      ..write(obj.medicineType)
      ..writeByte(5)
      ..write(obj.medicineTiming)
      ..writeByte(6)
      ..write(obj.afterFood)
      ..writeByte(7)
      ..write(obj.medicineDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
