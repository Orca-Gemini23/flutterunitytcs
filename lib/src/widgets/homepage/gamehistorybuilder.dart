import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/game_history_model.dart';
import 'package:walk/src/views/device/chart_details.dart';
// import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';

class GameHistoryBuilder extends StatefulWidget {
  const GameHistoryBuilder({super.key});

  @override
  State<GameHistoryBuilder> createState() => GameHistoryBuilderState();
}

class GameHistoryBuilderState extends State<GameHistoryBuilder> {
  // late Future<GameHistory?> userGameHistoryFuture;
  // @override
  // void initState() {
  //   super.initState();
  //   userGameHistoryFuture = FirebaseDB.getUserGameHistory();
  // }

  @override
  Widget build(BuildContext context) {
    // print("--------------------Building Game History Ui-------------------");
    String userName = LocalDB.user?.name ?? "Unknown User";
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userName)
          .snapshots(),
      builder: (context, snapshot) {
        if (LocalDB.user?.name != "Unknown User") {
          if (snapshot.hasData) {
            if (snapshot.data?.data() == null) {
              return const Center(
                child: Text("No data to show , please do a therapy sesssion"),
              );
            } else {
              return DetailChart(
                  historyData:
                      gameHistoryFromJson(jsonEncode(snapshot.data!.data())));
            }
          }
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Coming Soon"),
          );
        } else {
          return const Center(
            child: Text("please give details"),
          );
        }
      },
    );
  }
}
//     FutureBuilder<GameHistory?>(
//       future: userGameHistoryFuture,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           if (snapshot.data == null) {
//             return const Center(
//               child: Text("No data to show , please do a therapy sesssion"),
//             );
//           } else {
//             return DetailChart(historyData: snapshot.data!);
//           }
//         }
//         if (snapshot.hasError) {
//           return const Center(
//             child: Text("Coming Soon"),
//           );
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(
//               color: AppColor.greenDarkColor,
//               strokeWidth: 5,
//             ),
//           );
//         }
//       },
//     );
//   }
// }
