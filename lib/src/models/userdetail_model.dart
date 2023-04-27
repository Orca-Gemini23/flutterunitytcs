import 'dart:convert';

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

class UserDetails {
  String address;
  String age;
  String email;
  String gender;
  int id;
  String phone;
  String user;
  String userDeviceId;
  String userPaymentId;

  UserDetails({
    required this.address,
    required this.age,
    required this.email,
    required this.gender,
    required this.id,
    required this.phone,
    required this.user,
    required this.userDeviceId,
    required this.userPaymentId,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        address: json["address"] ?? "NA",
        age: json["age"] ?? "NA",
        email: json["email"] ?? "NA",
        gender: json["gender"] ?? "NA",
        id: json["id"],
        phone: json["phone"],
        user: json["user"] ?? "Unknown User",
        userDeviceId: json["user_device_id"] ?? "NA",
        userPaymentId: json["user_payment_id"] ?? "NA",
      );
}
