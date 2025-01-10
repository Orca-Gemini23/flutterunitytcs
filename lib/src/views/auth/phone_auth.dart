import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/firestoreusermodel.dart';
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/pages/account_page.dart';
import 'package:walk/src/utils/firebase/firebase_db.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/auth/otp_page.dart';

String countryCode = '';
String phoneNo = '';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({
    super.key,
  });

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  String phoneNumber = "";
  bool loading = false;
  String _verificationId = "";
  int? _resendToken;

  @override
  void initState() {
    FirebaseAnalytics.instance.logScreenView(screenName: 'Phone AuthPage').then(
          (value) => debugPrint("Analytics stated"),
        );
    super.initState();
  }

  var country = countries.firstWhere((element) => element.code == 'IN');

  bool isButton = false;

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    disabledBackgroundColor: Colors.grey,
    backgroundColor: const Color.fromRGBO(0, 87, 73, 1),
    minimumSize: Size(double.maxFinite, DeviceSize.isTablet ? 90 : 60),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(DeviceSize.isTablet ? 45 : 30)),
    ),
  );

  final TextEditingController numberController = TextEditingController();

  Future<void> openUrl(String url) async {
    final url0 = Uri.parse(url);
    if (!await launchUrl(url0)) {
      throw Exception('Could not launch $url0');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        leading: Platform.isIOS
            ? IconButton(
                icon: const Icon(
                    Icons.arrow_back_ios), // Different icon for back button
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        automaticallyImplyLeading: false,
      ),
      body: PopScope(
        canPop: Platform.isIOS,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, bottomInset == 0 ? 48.0 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        "Let’s get started.",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: DeviceSize.isTablet ? 48 : 24,
                            fontFamily: "Helvetica"),
                      ),
                      Text(
                        "What’s your number?",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: DeviceSize.isTablet ? 48 : 24,
                            fontFamily: "Helvetica"),
                      ),
                      SizedBox(
                        height: DeviceSize.isTablet ? 16 : 8,
                      ),
                      Text(
                        "We’ll send you a code to verify your phone.",
                        style: TextStyle(
                            fontWeight: FontWeight.lerp(
                                FontWeight.w400, FontWeight.w500, 0.5),
                            fontSize: DeviceSize.isTablet ? 28 : 14,
                            fontFamily: "Helvetica"),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 48,
              ),
              Text(
                "Phone Number",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: DeviceSize.isTablet ? 28 : 14,
                    fontFamily: "Helvetica"),
              ),
              SizedBox(
                height: DeviceSize.isTablet ? 18 : 12,
              ),
              IntlPhoneField(
                controller: numberController,
                style: DeviceSize.isTablet
                    ? const TextStyle(
                        fontSize: 28,
                        fontFamily: "Helvetica",
                      )
                    : null,
                validator: (p0) {
                  country = countries.firstWhere(
                      (element) => element.code == p0?.countryISOCode);
                  if (p0!.number.length >= country.minLength &&
                      p0.number.length <= country.maxLength) {
                    setState(() {
                      isButton = true;
                    });
                  } else {
                    setState(() {
                      isButton = false;
                    });
                  }
                  return null;
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  hintStyle: TextStyle(
                      fontFamily: "Helvetica",
                      fontSize: DeviceSize.isTablet ? 28 : 14,
                      fontWeight: FontWeight.w400),
                  counterText: '',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'IN',
                dropdownTextStyle: DeviceSize.isTablet
                    ? const TextStyle(
                        fontSize: 28,
                        fontFamily: "Helvetica",
                      )
                    : null,
                dropdownIcon: Icon(Icons.arrow_drop_down,
                    size: DeviceSize.isTablet ? 48 : 24),
                showCountryFlag: !DeviceSize.isTablet,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                onChanged: (phone) {
                  phoneNumber = phone.completeNumber;
                  countryCode = phone.countryCode;
                  phoneNo = phone.number;
                },
                onCountryChanged: (c) {
                  setState(() {
                    numberController.clear();
                    isButton = false;
                  });
                },
              ),
              const Spacer(),
              Column(
                children: [
                  Platform.isIOS
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text.rich(
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 9,
                                fontFamily: "Helvetica"),
                            TextSpan(
                              children: [
                                const TextSpan(text: "Don't have a account? "),
                                TextSpan(
                                  text: " Continue as guest",
                                  style: const TextStyle(
                                      color: Color(
                                          0xFF2DBA9B)), //decoration: TextDecoration.underline
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = !loading
                                        ? () async {
                                            setState(() {
                                              loading = true;
                                            });
                                            try {
                                              debugPrint(
                                                  "Signed in with temporary account.");
                                              setState(() {
                                                UserDetails.unavailable = true;
                                                // UserDetails.iosUnavailable =
                                                //     true;
                                              });
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AccountPage(),
                                                  settings: const RouteSettings(
                                                      name: '/accountpage'),
                                                ),
                                              );
                                              await FirebaseAuth.instance
                                                  .signInAnonymously();
                                              Analytics.start();
                                              await Analytics.addNavigation(
                                                  AnalyticsNavigationModel(
                                                          landingPage:
                                                              "First Time User",
                                                          landTime: DateTime
                                                              .timestamp())
                                                      .toJson());

                                              for (var data in CollectAnalytics
                                                  .initialData) {
                                                await Analytics.addNavigation(
                                                    data);
                                              }
                                              await Analytics.addNavigation(
                                                  AnalyticsNavigationModel(
                                                          landingPage:
                                                              "First Time Anonymous User",
                                                          landTime: DateTime
                                                              .timestamp())
                                                      .toJson());
                                              setState(() {
                                                loading = false;
                                              });
                                            } on FirebaseAuthException catch (e) {
                                              setState(() {
                                                loading = false;
                                              });
                                              if (kDebugMode) {
                                                print(e);
                                              }
                                            }
                                          }
                                        : null,
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text.rich(
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: DeviceSize.isTablet ? 13.5 : 9,
                          fontFamily: "Helvetica"),
                      TextSpan(
                        children: [
                          const TextSpan(text: "By signing up you accept our "),
                          TextSpan(
                            text: "terms of service",
                            style: const TextStyle(
                                color: Color(
                                    0xFF2DBA9B)), //decoration: TextDecoration.underline
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                openUrl(
                                    'https://www.lifesparktech.com/terms-and-conditions');

                                CollectAnalytics.initialData.add(
                                    AnalyticsClicksModel(
                                            click: "Terms&ConditionLink",
                                            clickTime: DateTime.timestamp())
                                        .toJson());
                              },
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "privacy policy",
                            style: const TextStyle(
                                color: Color(
                                    0xFF2DBA9B)), //decoration: TextDecoration.underline
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                openUrl(
                                    'https://www.lifesparktech.com/privacy-policy');

                                CollectAnalytics.initialData.add(
                                    AnalyticsClicksModel(
                                            click: "PrivacyPolicyLink",
                                            clickTime: DateTime.timestamp())
                                        .toJson());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      style: elevatedButtonStyle,
                      onPressed: isButton
                          ? () async {
                              setState(() {
                                loading = true;
                              });
                              Analytics.start(
                                  authNumber: "$countryCode$phoneNo");
                              await Analytics.addNavigation(
                                  AnalyticsNavigationModel(
                                          landingPage: "First Time User",
                                          landTime: DateTime.timestamp())
                                      .toJson());

                              for (var data in CollectAnalytics.initialData) {
                                await Analytics.addNavigation(data);
                              }

                              var newUser = UserModel(
                                name: "Unknown User",
                                age: "XX",
                                phone: "$countryCode $phoneNo",
                                image: "NA",
                                gender: "XX",
                                address: "XX",
                                email: "XX",
                              );

                              LocalDB.saveUser(newUser);
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: phoneNumber,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {},
                                verificationFailed: (FirebaseAuthException e) {
                                  debugPrint(e.toString());
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  setState(() {
                                    loading = false;
                                    _verificationId = verificationId;
                                    _resendToken = resendToken;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OTPPage(
                                        verificationId: verificationId,
                                        resendToken: resendToken,
                                        phoneNumber: phoneNumber,
                                      ),
                                      settings:
                                          const RouteSettings(name: '/otppage'),
                                    ),
                                  );
                                },
                                forceResendingToken: _resendToken,
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {
                                  verificationId = _verificationId;
                                },
                              );
                            }
                          : null,
                      child: !loading
                          ? Text(
                              'Continue',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: DeviceSize.isTablet ? 24 : 16,
                                  fontFamily: "Helvetica"),
                            )
                          : LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: DeviceSize.isTablet ? 45 : 30,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
