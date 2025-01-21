import 'package:flutter/cupertino.dart';
import 'package:walk/src/models/game_history_model.dart';

class GameHistoryController extends ChangeNotifier {
  List<GameHistory> _gameHistory = [];

  void update(List<GameHistory> newHistory) {
    _gameHistory = newHistory;
    notifyListeners();
  }

  List<GameHistory> get gameHistory => _gameHistory;
}
