import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walk/src/models/game_history_model.dart';
import 'package:walk/src/views/device/chart_details.dart';

class GameHistoryBuilder extends StatefulWidget {
  const GameHistoryBuilder({super.key});

  @override
  State<GameHistoryBuilder> createState() => GameHistoryBuilderState();
}

class GameHistoryBuilderState extends State<GameHistoryBuilder> {
  @override
  Widget build(BuildContext context) {
    // print("--------------------Building Game History Ui-------------------");
    String? userName = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userName)
          .snapshots(),
      builder: (context, snapshot) {
        if (userName.isNotEmpty) {
          if (snapshot.hasData) {
            if (snapshot.data?.data() == null) {
              return const Center(
                child: Text("No data to show , please do a therapy session"),
              );
            } else {
              return Stack(
                children: [
                  DetailChart(
                      historyData: gameHistoryFromJson(
                          jsonEncode(snapshot.data!.data()))),
                ],
              );
            }
          }
        } else {
          return const Center(
            child: Text(
              "The report is not available.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Coming Soon"),
          );
        } else {
          return const Center(
            child: Text(
              "The report is not yet available.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }
      },
    );
  }
}
