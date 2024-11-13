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
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/auth/otp_page.dart';
import 'package:walk/src/views/user/newrevisedaccountpage.dart';

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
    minimumSize: const Size(double.maxFinite, 60),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
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
                      const Text(
                        "Let’s get started.",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            fontFamily: "Helvetica"),
                      ),
                      const Text(
                        "What’s your number?",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            fontFamily: "Helvetica"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "We’ll send you a code to verify your phone.",
                        style: TextStyle(
                            fontWeight: FontWeight.lerp(
                                FontWeight.w400, FontWeight.w500, 0.5),
                            fontSize: 14,
                            fontFamily: "Helvetica"),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 48,
              ),
              const Text(
                "Phone Number",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: "Helvetica"),
              ),
              const SizedBox(
                height: 12,
              ),
              IntlPhoneField(
                controller: numberController,
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
                decoration: const InputDecoration(
                  hintText: 'Enter phone number',
                  hintStyle: TextStyle(
                      fontFamily: "Helvetica",
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  counterText: '',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'IN',
                // showCountryFlag: false,
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
                                    ..onTap = () async {
                                      try {
                                        debugPrint(
                                            "Signed in with temporary account.");
                                        setState(() {
                                          // UserDetails.unavailable = true;
                                          UserDetails.iosUnavailable = true;
                                        });
                                        Go.pushReplacement(
                                          context: context,
                                          pushReplacement:
                                              const NewRevisedAccountPage(),
                                        );
                                        await FirebaseAuth.instance
                                            .signInAnonymously();
                                      } on FirebaseAuthException catch (e) {
                                        if (kDebugMode) {
                                          print(e);
                                        }
                                      }
                                    },
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
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 9,
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
                                  Go.to(
                                    context: context,
                                    push: OTPPage(
                                      verificationId: verificationId,
                                      resendToken: resendToken,
                                      phoneNumber: phoneNumber,
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
                          ? const Text(
                              'Continue',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  fontFamily: "Helvetica"),
                            )
                          : LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 30,
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
