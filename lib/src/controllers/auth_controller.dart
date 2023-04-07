import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AuthController extends ChangeNotifier {
  // Future registerUser(String firstName, String lastName, String email,
  //     String phoneNumber, String city, String gender, String password) async {
  //   try {
  //     var uri = Uri.parse("http://10.0.2.2:3000/users/register_user/");
  //     var body = {
  //       "fname": firstName,
  //       "lname": lastName,
  //       "email": email,
  //       "phone": phoneNumber,
  //       "city": city,
  //       "gender": gender[0],
  //       "password": password,
  //     };
  //     var response = await http.post(uri,
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //         },
  //         body: jsonEncode(body));
  //     var result = response.body;
  //     log(result.toString());
  //   } catch (e) {
  //     log("error occurred" + e.toString());
  //   }
  // }
}
