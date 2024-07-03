import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/utils/awshelper.dart/awsauth.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/views/auth/otp_page.dart';

String countryCode = '';
String phoneNo = '';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage(
      {super.key,
      required this.isSignIn,
      required this.isLoggedIn,
      required this.logOut});
  final bool isSignIn;
  final Function isLoggedIn;
  final Function logOut;
  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    // AWSAuth.fetchAuthSession();
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -140,
              left: -140,
              child: Image.asset(AppAssets.backgroundImage),
            ),
            Container(
              height: Screen.height(context: context),
              width: Screen.width(context: context),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: Screen.height(context: context) * 0.45,
                    ),
                    const Text(
                      AppString.enterNumber,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: Screen.height(context: context) * 0.05,
                    ),
                    IntlPhoneField(
                      decoration: const InputDecoration(
                        // labelText: 'Phone Number',
                        suffixIcon: Icon(Icons.phone_android),
                      ),
                      initialCountryCode: 'IN',
                      showDropdownIcon: false,
                      showCountryFlag: false,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      onChanged: (phone) {
                        // print(phone.completeNumber);
                        phoneNumber = phone.completeNumber;
                        countryCode = phone.countryCode;
                        phoneNo = phone.number;
                      },
                    ),
                    // getTextfield(
                    //     "Enter Number", _phoneController, Icons.phone_android),
                    SizedBox(
                      height: Screen.height(context: context) * 0.1,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        print(phoneNumber);
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
                        //add checks and submit details
                        // Go.to(
                        //   context: context,
                        //   push: OTPPage(
                        //     phoneNumber: phoneNumber,
                        //     isSignIn: widget.isSignIn,
                        //   ),
                        // );
                        // widget.isSignIn
                        //     ? await AWSAuth.signInWithPhoneVerification(
                        //         phoneNumber,
                        //         "password",
                        //         context,
                        //         widget.isSignIn,
                        //         widget.isLoggedIn,
                        //         widget.logOut)
                        //     : await AWSAuth.signUpWithPhoneVerification(
                        //         phoneNumber,
                        //         "password",
                        //         context,
                        //         widget.isSignIn,
                        //         widget.isLoggedIn,
                        //         widget.logOut);
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: phoneNumber,
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {
                                await FirebaseAuth.instance.signInWithCredential(credential);
                              },
                          verificationFailed: (FirebaseAuthException e) {
                            log(e.toString());
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            print("hello");
                            Go.pushReplacement(
                              context: context,
                              pushReplacement: OTPPage(
                                verificationId: verificationId,
                                resendToken: resendToken,
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        fixedSize: const Size(200, 50),
                        backgroundColor: const Color(0xff005749),
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        AppString.sendOtp,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
