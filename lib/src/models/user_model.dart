import 'dart:convert';
import 'package:hive/hive.dart';
part 'user_model.g.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

@HiveType(typeId: 2)
class UserModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String age;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final String address;

  @HiveField(5)
  final String email;

  UserModel({
    required this.name,
    required this.age,
    required this.phone,
    required this.gender,
    required this.address,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"] ?? "Unknown User",
        age: json["age"] ?? "XX",
        phone: json["phone"] ?? "XX",
        gender: json["gender"] ?? "XX",
        address: json["address"] ?? "XX",
        email: json["email"] ?? "XX",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "phone": phone,
        "gender": gender,
        "address": address,
        "email": email
      };
}
