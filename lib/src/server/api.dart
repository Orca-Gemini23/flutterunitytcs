import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/firestoreusermodel.dart';
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/auth/phone_auth.dart';
import 'package:walk/src/views/pages/AccountPage.dart';

Future<bool> isNetworkAvailable() async {
  // var connectivityResult = await Connectivity().checkConnectivity();
  // return connectivityResult != ConnectivityResult.none;
  return true;
}

class API {
  static addData(List<dynamic> score) async {
    var baseUrl = (country == "India")
        ? "https://f02966xlb7.execute-api.ap-south-1.amazonaws.com/flutterdata/flutter-app-s3-ap-south-1-mumbai/"
        : "https://wcdq86190h.execute-api.eu-west-2.amazonaws.com/DevS/flutter-app-s3-eu-west-2-london/";

    debugPrint("score is coming");

    var jsonData = jsonEncode(score);
    String game = '';

    if (jsonData[1] == '2') {
      game = "Fish";
    } else if (jsonData[1] == '1') {
      game = "Swing";
    } else {
      game = "Ball";
    }

    var url = Uri.parse(
      "$baseUrl${LocalDB.user!.name.replaceAll(' ', '')}/$game-${DateTime.now().toString().replaceAll(' ', '')}.json",
    );

    try {
      final res = await http.put(url, body: jsonData);
      if (res.statusCode == 200) {
        var data = res.body.toString();
        debugPrint("Data written to file successfully: $data");
      } else {
        debugPrint("Failed to write data to the file");
      }
    } catch (e) {
      debugPrint("API Error: ${e.toString()}");
    }
  }

  static getScore() async {
    try {
      final result = await FirebaseFunctions.instanceFor(region: "us-central1")
          .httpsCallable('user_gaitscore')
          .call();
      return result.data;
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  static getUserDetails() async {
    try {
      UserModel newUser;
      await FirebaseFunctions.instanceFor(region: "us-central1")
          .httpsCallable('user_data')
          .call()
          .then((result) => {
                if (result.data?["data"]?.length != 0)
                  {
                    newUser = UserModel(
                        name: result.data["data"][0]["Name"] ?? "Unknown User",
                        age: "${result.data["data"][0]["Age"]}",
                        phone: "$countryCode $phoneNo",
                        image: "NA",
                        gender: result.data["data"][0]["Gender"] ?? "XX",
                        address: result.data["data"][0]["Address"] ?? "XX",
                        email: result.data["data"][0]["Email"] ?? "XX"),
                    LocalDB.saveUser(newUser),
                  }
              });
    } catch (error) {
      log(error.toString());
    }
  }

  static Future<dynamic> getUserDetailsFireStore() async {
    // retriving data
    await FirebaseFirestore.instance
        .collection("UserProfiles")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          if (data.isNotEmpty) {
            if (data["User Details"] != null &&
                data["User Details"] is List &&
                data["User Details"].isNotEmpty) {
              var userData = data["User Details"]?.last as Map<String, dynamic>;
              UserModel newUser = UserModel(
                name: userData["userName"] ?? "Unknown User",
                age: userData["userAge"],
                phone: userData["userPhone"] ?? LocalDB.user!.phone,
                image: "NA",
                gender: userData["userGender"] ?? "XX",
                address: userData["userAddress"] ?? "XX",
                email: userData["userEmail"] ?? "XX",
              );
              LocalDB.saveUser(newUser);
              DetailsPage.height = userData["userHeight"];
              DetailsPage.weight = userData["userWeight"];
              PreferenceController.saveStringData(
                  "Height", userData["userHeight"] ?? "");
              PreferenceController.saveStringData(
                  "Weight", userData["userWeight"] ?? "");
            }
          }
        } else {
          await getUserDetails();
          if (LocalDB.user!.name == "Unknown User") {
            FirestoreUserModel userDetails = FirestoreUserModel(
              userName: LocalDB.user!.name,
              userPhone: LocalDB.user!.phone,
              userGender: LocalDB.user!.gender,
              userAge: LocalDB.user!.age,
              userEmail: LocalDB.user!.email,
              userAddress: LocalDB.user!.address,
              userHeight: "",
              userWeight: "",
              loginTime: DateTime.now(),
            );
            FirebaseFirestore.instance
                .collection("UserProfiles")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set({
              "User Details": FieldValue.arrayUnion([userDetails.toJson()]),
            }, SetOptions(merge: true));
          }
        }
      },
      onError: (e) => debugPrint("Error getting document: $e"),
    );
  }
}
