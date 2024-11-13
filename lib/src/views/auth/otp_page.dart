import 'dart:async';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/server/api.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/auth/phone_auth.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';
import 'package:walk/src/views/user/newrevisedaccountpage.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({
    super.key,
    required this.verificationId,
    this.resendToken,
    required this.phoneNumber,
  });

  final String verificationId;
  final int? resendToken;
  final String phoneNumber;
  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _otpController = TextEditingController();

  int count = 0;
  int t = 30;
  bool loading = false;
  String _verificationId = "";
  int? _resendToken;
  bool flag = true;

  @override
  void initState() {
    FirebaseAnalytics.instance
        .logScreenView(screenName: 'OTP Page')
        .then((value) => debugPrint("Analytics stated in OTP Page"));
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          t--;
        });
      }
      if (t == 0) {
        timer.cancel();
      }
    });
    super.initState();
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(0, 87, 73, 1),
    disabledBackgroundColor: Colors.grey,
    minimumSize: const Size(double.maxFinite, 60),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back_ios), // Different icon for back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset == 0 ? 48.0 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'OTP Verification',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontFamily: "Helvetica",
              ),
            ),
            // const SizedBox(height: 46),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              "Enter 6 digit code sent to $phoneNo",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: "Helvetica",
              ),
            ),
            const SizedBox(height: 25),
            Pinput(
              length: 6,
              controller: _otpController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            // const SizedBox(height: 86),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Didn't Receive OTP? ",
                      style: TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Helvetica",
                      ),
                    ),
                    // t == 0 ?
                    TextButton(
                      onPressed: t == 0
                          ? () async {
                              // loading = true;
                              setState(() {
                                t = 30;
                              });
                              Timer.periodic(const Duration(seconds: 1),
                                  (timer) {
                                setState(() {
                                  t--;
                                });
                                if (t == 0) {
                                  timer.cancel();
                                }
                              });
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: widget.phoneNumber,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {
                                  _otpController.setText(credential.smsCode!);
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  debugPrint(e.toString());
                                  // Fluttertoast.showToast(msg: e.toString());
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
                                },
                                forceResendingToken: _resendToken,
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {
                                  verificationId = _verificationId;
                                },
                              );
                            }
                          : null,
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(
                          color: t == 0
                              ? const Color(0xFF2DBA9B)
                              : const Color(0xFF94A3B8),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          fontFamily: "Helvetica",
                        ),
                      ),
                    ),
                    // : Text(
                    //     "Resend in $t sec",
                    //     style: const TextStyle(
                    //         color: Color(0xFF475569),
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w400),
                    //   ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  t >= 10 ? "Resend code in 00:$t" : "Resend code in 00:0$t",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Helvetica",
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.3,
            // ),
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: _otpController.text.length == 6
                  ? () async {
                      setState(() {
                        loading = true;
                      });
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: _otpController.text);

                      try {
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        setState(() {
                          flag = true;
                        });
                        await API.getUserDetails();
                        await API.getUserDetailsFireStore();
                        log("page change");
                        if (LocalDB.user!.name == "Unknown User" ||
                            DetailsPage.weight.isEmpty) {
                          setState(() {
                            UserDetails.unavailable = true;
                          });
                          if (context.mounted) {
                            Go.pushAndRemoveUntil(
                              context: context,
                              pushReplacement: const NewRevisedAccountPage(),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            Go.pushAndRemoveUntil(
                              context: context,
                              pushReplacement: const RevisedHomePage(),
                            );
                          }
                        }
                      } on FirebaseAuthException catch (e) {
                        Fluttertoast.showToast(msg: e.code);
                        setState(() {
                          _otpController.clear();
                          flag = false;
                        });

                        loading = false;
                      } catch (e) {
                        setState(() {
                          _otpController.clear();
                          flag = false;
                        });
                        debugPrint(e.toString());
                      }
                    }
                  : null,
              child: !loading
                  ? const Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400, fontSize: 16),
                    )
                  : LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 30,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
