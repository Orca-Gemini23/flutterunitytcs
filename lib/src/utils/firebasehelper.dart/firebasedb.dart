// import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/user/newrevisedaccountpage.dart';
// import 'package:walk/src/models/game_history_model.dart';

class FirebaseDB {
  static FirebaseFirestore currentDb = FirebaseFirestore.instance;

  static Future<bool> initFirebaseServices() async {
    try {
      await Firebase.initializeApp();

      if (country == "England") {
        currentDb = FirebaseFirestore.instanceFor(
            app: Firebase.app(), databaseId: "walkeu");
      } else {
        currentDb = FirebaseFirestore.instance;
      }
      currentDb.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      return true;
    } catch (e) {
      log("error in initFirebaseServices ${e.toString()}");
      return false;
    }
  }

  static void uploadBallData({required String ballData}) {
    var data = ballData.split(",");
    var dataMap = {for (var i = 0; i < data.length; i++) i.toString(): data[i]};
    DateTime now = DateTime.now();
    String date = "${now.year}, ${now.month}, ${now.day}";
    try {
      currentDb
          .collection("GameData")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("BallData")
          .doc(date.toString())
          .collection(data[22])
          .add(dataMap);
    } catch (e) {
      log("error in uploadingBallData ${e.toString()}");
    }
  }

  static void uploadSwingData({required String swingData}) {
    DateTime now = DateTime.now();
    String date = "${now.year}, ${now.month}, ${now.day}";
    var data = swingData.split(",");
    var dataMap = {for (var i = 0; i < data.length; i++) i.toString(): data[i]};
    try {
      currentDb
          .collection("GameData")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("SwingData")
          .doc(date.toString())
          .collection(data[30])
          .add(dataMap);
    } catch (e) {
      log("error in uploadingBallData ${e.toString()}");
    }
  }

  static void uploadFishData({required String fishData}) {
    DateTime now = DateTime.now();
    String date = "${now.year}, ${now.month}, ${now.day}";
    var data = fishData.split(",");
    var dataMap = {for (var i = 0; i < data.length; i++) i.toString(): data[i]};
    try {
      currentDb
          .collection("GameData")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("FishData")
          .doc(date.toString())
          .collection(data[18])
          .add(dataMap);
    } catch (e) {
      log("error in uploadingBallData ${e.toString()}");
    }
  }

  static Future<bool> uploadUserScore(
      {int? score, int? secondsPlayedFor, DateTime? playedOn}) async {
    try {
      var fireBaseInstance = FirebaseFirestore.instance;
      String userName = FirebaseAuth.instance.currentUser!.uid;
      String gamePlayedString = playedOn?.toLocal().toString() ?? "NA";
      Map<String, dynamic> gameDetails = {
        "score": score,
        "playedOn": gamePlayedString,
        "secondsPlayedFor": secondsPlayedFor,
      };

      List gameHistory = [gameDetails];

      fireBaseInstance.collection("users").doc(userName).set(
          {"gameHistory": FieldValue.arrayUnion(gameHistory)},
          SetOptions(merge: true));

      return true;
    } catch (e) {
      log("error in uploadingUserScore ${e.toString()}");
      return false;
    }
  }

  static Future<void> getNumbers() async {
    try {
      currentDb
          .collection("AdvancedMode")
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .get()
          .then(
        (DocumentSnapshot doc) async {
          if (doc.exists) {
            AdvancedMode.modeSettingVisible = true;
          }
        },
      );
    } catch (e) {
      log("error in uploadingUserScore ${e.toString()}");
    }
  }
}
