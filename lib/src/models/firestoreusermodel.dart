class FirestoreUserModel {
  final String userName;
  final String userAge;
  final String userGender;
  final String userPhone;
  final String userAddress;
  final String userEmail;
  final String userHeight;
  final String userWeight;
  // final List<int> userScores;
  // final DateTime updatedOn;

  FirestoreUserModel({
    required this.userName,
    required this.userPhone,
    required this.userGender,
    required this.userAge,
    required this.userEmail,
    required this.userAddress,
    required this.userHeight,
    required this.userWeight,
  });

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userPhone": userPhone,
        "userAge": userAge,
        "userGender": userGender,
        "userEmail": userEmail,
        "userAddress": userAddress,
        "userHeight": userHeight,
        "userWeight": userWeight,
        // "userScores": userScores,
        // "updatedOn": updatedOn,
      };
}
