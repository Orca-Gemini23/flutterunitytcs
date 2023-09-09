class FirestoreUserModel {
  final String userName;
  final int userAge;
  final String userGender;
  final String userPhone;
  final List<int> userScores;
  final DateTime updatedOn;

  FirestoreUserModel({
    required this.userName,
    required this.userPhone,
    required this.userGender,
    required this.userAge,
    required this.userScores,
    required this.updatedOn,
  });

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userPhone": userPhone,
        "userAge": userAge,
        "userGender": userGender,
        "userScores": userScores,
        "updatedOn": updatedOn,
      };
}
