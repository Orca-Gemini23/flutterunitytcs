// import 'dart:convert';
// import 'dart:developer';

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:walk/src/constants/api_constants.dart';
import 'package:walk/src/controllers/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  String customerAuthToken = "";
  String get getCustomerAuthToken => customerAuthToken;
  setCustomerAuthToken(String token) {
    customerAuthToken = token;
    notifyListeners();
  }

  Future<bool> registerUser(String firstName, String email, String phoneNumber,
      String city, String gender, String age) async {
    try {
      var uri = Uri.parse(REGISTER_USER_ENDPOINT);
      var body = {
        "name": firstName,
        "email": email,
        "phone": phoneNumber,
        "address": city,
        "age": age,
        "gender": gender,
      };
      var response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));
      var result = jsonDecode(response.body);
      if (result["status"] == "Success") {
        Fluttertoast.showToast(
            msg: "Registration Succesful , Now you can login to access WALK");
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Registration was unsuccessful ,Please Try again");
        return false;
      }
    } catch (e) {
      log("error occurred" + e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
      return false;
    }
  }

  Future<bool> sendOtp(String email) async {
    try {
      var uri = Uri.parse(SEND_OTP_ENDPOINT);
      var body = {"email": email};
      Fluttertoast.showToast(msg: "Sending Otp");
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      var result = jsonDecode(response.body);

      if (result["status"] == "Success") {
        Fluttertoast.showToast(msg: "Otp sent Successfully");
        log("coming here");
        return true;
      } else {
        Fluttertoast.showToast(msg: result["message"]);
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      var uri = Uri.parse(VERIFY_OTP_ENDPOINT);
      var body = {"email": email, "otp": otp};
      Fluttertoast.showToast(msg: "Sending Otp");
      var response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      var result = jsonDecode(response.body);
      log(result.toString());
      if (result["status"] == "Success") {
        Fluttertoast.showToast(msg: "Otp verified Successfully");
        PreferenceController.saveStringData(
            "customerAuthToken", result["customerAuthToken"]);
        setCustomerAuthToken(result["customerAuthToken"]);

        ///TODO : CREATE A USER DETAILS MODEL HERE , SO THAT HIS DETAILS CAN BE SAVED AND SHOWN IN THE NAVIGATION DRAWER
        return true;
      } else {
        Fluttertoast.showToast(msg: result["message"]);
        return false;
      }
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong please try again");
      return false;
    }
  }
}
