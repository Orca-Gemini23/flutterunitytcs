class FirestoreUserModel {
  final String userName;
  final String userAge;
  final String userGender;
  final String userPhone;
  final String userAddress;
  final String userEmail;
  final String userHeight;
  final String userWeight;
  final DateTime loginTime;
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
    required this.loginTime,
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
        "loginTime": loginTime,
        // "userScores": userScores,
        // "updatedOn": updatedOn,
      };
}

class AnalyticsNavigationModel {
  final String landingPage;
  final DateTime landTime;

  AnalyticsNavigationModel({required this.landingPage, required this.landTime});

  Map<String, dynamic> toJson() => {
        "landingPage": landingPage,
        "landTime": landTime,
      };
}

class AnalyticsClicksModel {
  final String click;
  final DateTime clickTime;

  AnalyticsClicksModel({required this.click, required this.clickTime});

  Map<String, dynamic> toJson() => {
        "click": click,
        "clickTime": clickTime,
      };
}
