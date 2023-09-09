// To parse this JSON data, do
//
//     final gameHistory = gameHistoryFromJson(jsonString);

import 'dart:convert';

GameHistory gameHistoryFromJson(String str) =>
    GameHistory.fromJson(json.decode(str));

class GameHistory {
  List<GameHistoryElement>? gameHistory;

  GameHistory({
    this.gameHistory,
  });

  factory GameHistory.fromJson(Map<String, dynamic> json) => GameHistory(
        gameHistory: json["gameHistory"] == null
            ? []
            : List<GameHistoryElement>.from(json["gameHistory"]!
                .map((x) => GameHistoryElement.fromJson(x))),
      );
}

class GameHistoryElement {
  String? playedOn;
  int? score;
  int? secondsPlayedFor;

  GameHistoryElement({
    this.playedOn,
    this.score,
    this.secondsPlayedFor,
  });

  factory GameHistoryElement.fromJson(Map<String, dynamic> json) =>
      GameHistoryElement(
        playedOn: json["playedOn"] ?? "NA",
        score: json["score"] ?? 0,
        secondsPlayedFor: json["secondsPlayedFor"] ?? 0,
      );
}
