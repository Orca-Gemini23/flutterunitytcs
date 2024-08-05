// import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/views/user/revisedaccountpage.dart';
// import 'package:walk/src/models/game_history_model.dart';

class FirebaseDB {
  static FirebaseFirestore currentDb=FirebaseFirestore.instance;

  static Future<bool> initFirebaseServices() async {
    try {
      await Firebase.initializeApp();
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      print(country);

      if(country=="England")
        {
          currentDb=FirebaseFirestore.instanceFor(app: Firebase.app(),databaseURL: "walkeu");
        }
      else {
        currentDb= FirebaseFirestore.instance;
      }
      // FirebaseFirestore.instanceFor(app: Firebase.app(),databaseURL: "walkeu");
      currentDb.collection("collectionPath").add({"test":"test"});

      return true;
    } catch (e) {
      log("error in initFirebaseServices ${e.toString()}");
      return false;
    }
  }
  static void uploadBallData({String? ballData}){
    currentDb.collection("GameData").doc(LocalDB.user!.phone.toString() ).collection("BallData").add({"data":ballData});
}
  static void uploadSwingData({required String swingData}) {
     currentDb.collection("GameData").doc(LocalDB.user!.phone.toString()).collection("SwingData").add({"data":swingData});
  }
  static void uploadFishData({required String fishData}) {
    currentDb.collection("GameData").doc(LocalDB.user!.phone.toString()).collection("FishData").add({"data":fishData});
  }


  static Future<bool> uploadUserScore(
      {int? score, int? secondsPlayedFor, DateTime? playedOn}) async {
    try {
      var fireBaseInstance = FirebaseFirestore.instance;
      String userName = LocalDB.user!.phone;
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

  static Future<bool> storeGameData(List<dynamic> data) async {
    try {
      var fireBaseInstance = FirebaseFirestore.instance;
      String userName = LocalDB.user!.name;

      await fireBaseInstance
          .collection("user")
          .doc(userName)
          .collection("test")
          .add({"score": data});
      return true;
    } catch (e) {
      log("error in uploadingUserScore ${e.toString()}");
      return false;
    }
  }


  // static Future<GameHistory?> getUserGameHistory() async {
  //   try {
  //     GameHistory? gameHistory;
  //     if (LocalDB.user?.name != "Unknown User") {
  //       var firebaseInstance = FirebaseFirestore.instance;
  //       String userName = LocalDB.user?.name ?? "Unknown User";
  //       DocumentReference documentRefrence =
  //           firebaseInstance.collection("users").doc(userName);
  //       await documentRefrence.get().then((snapshot) {
  //         log("Data from firebase ${snapshot.data()}");

  //         gameHistory = gameHistoryFromJson(jsonEncode(snapshot.data()));
  //       });
  //     }

  //     return gameHistory;
  //   } catch (e) {
  //     log(
  //       e.toString(),
  //     );
  //     throw "Something went wrong";
  //   }
  // }
}
