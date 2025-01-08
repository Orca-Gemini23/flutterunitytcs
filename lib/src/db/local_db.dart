import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart' as hive;
import 'package:walk/src/models/user_model.dart';

/// Initializing Hive for local storage
Future<void> initializeLocalDatabase() async {
  try {
    await Hive.initFlutter();
    hive.Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<UserModel>('userBox');
  } catch (e) {
    log('error initializing local database: $e');
  }
}

/// Closing hive and all its boxes
Future<void> disposeHiveBox() async {
  try {
    await Hive.close();
  } catch (e) {
    log('error disposing/closing local database: $e');
  }
}

class LocalDB {
  /// Instance of Hive box for storing prescriptions
  static UserModel defaultUser = UserModel(
    name: "Unknown User",
    age: "XX",
    phone: "",
    image: "NA",
    gender: "XX",
    address: "XX",
    email: "XX",
  );


  static Box<UserModel> userBox() => Hive.box<UserModel>("userBox");

  static UserModel? get user => userBox().get(0, defaultValue: defaultUser);

  static saveUser(UserModel newUser) {
    userBox().put(0, newUser);
  }

  static ValueListenable<Box<UserModel>> listenableUser() =>
      userBox().listenable();


}