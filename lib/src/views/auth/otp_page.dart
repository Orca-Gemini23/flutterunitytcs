import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/server/api.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/auth/phone_auth.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({
    super.key,
    required this.verificationId,
    this.resendToken,
    required this.phoneNumber,
    // required this.isSignIn,
    // required this.isLoggedIn,
    // required this.logOut,
  });

  final String verificationId;
  final int? resendToken;
  final String phoneNumber;
  // final bool isSignIn;
  // final Function isLoggedIn;
  // final Function logOut;
  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _otpController = TextEditingController();
  // final RoundedLoadingButtonController _buttonController =
  //     RoundedLoadingButtonController();

  int count = 0;
  int t = 30;
  bool loading = false;
  String _verificationId = "";
  int? _resendToken;
  bool flag = true;

  @override
  void initState() {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'OTP Page').then(
          (value) => debugPrint("Analytics stated"),
        );
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
                                    (PhoneAuthCredential credential) async {},
                                verificationFailed:
                                    (FirebaseAuthException e) {
                                  debugPrint(e.toString());
                                  Fluttertoast.showToast(msg: e.toString());
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                codeSent: (String verificationId,
                                    int? resendToken) {
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
                      // if (_otpController.text.length == 6) {
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

                      await API.getUserDetails();

                      // ignore: use_build_context_synchronously
                      Go.pushAndRemoveUntil(
                        context: context,
                        pushReplacement: const RevisedHomePage(),
                      );

                      // }
                    }
                  : null,
              child: !loading
                  ? const Text(
                      'Continue',
                      style: TextStyle(
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

// body: SizedBox(
//   width: double.infinity,
//   height: double.infinity,
//   child: Padding(
//     // padding: const EdgeInsets.symmetric(horizontal: 10.0),
//     padding: const EdgeInsets.all(24),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Text(
//           'OTP Verification',
//           style: TextStyle(
//             fontSize: 30,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 46),
//         Text("Enter 6 digit code sent to $phoneNo"),
//         const SizedBox(height: 25),
//         Pinput(
//           length: 6,
//           controller: _otpController,
//         ),
//         const SizedBox(height: 86),
//         Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const Text(
//                   "Didn’t Receive Code?",
//                   style: TextStyle(
//                       color: Color(0xFF475569),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400),
//                 ),
//                 TextButton(
//                   onPressed: () async {},
//                   child: const Text(
//                     "Resend Code",
//                     style: TextStyle(
//                       color: Color(0xFF94A3B8),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               "Resend code in 00:59",
//               style: TextStyle(
//                   color: Color(0xFF475569),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400),
//             ),
//           ],
//         ),
//         const Spacer(),
//         ElevatedButton(
//           style: raisedButtonStyle,
//           onPressed: () async {
//             if (_otpController.text.length == 6) {
//               PhoneAuthCredential credential =
//                   PhoneAuthProvider.credential(
//                       verificationId: widget.verificationId,
//                       smsCode: _otpController.text);
//               await FirebaseAuth.instance
//                   .signInWithCredential(credential);
//               // ignore: use_build_context_synchronously
//               Go.pushAndRemoveUntil(
//                 context: context,
//                 pushReplacement:
//                     RevisedHomePage(isLoggedIn: () {}, logOut: () {}),
//               );
//             }
//           },
//           child: const Text(
//             'Continue',
//             style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
//           ),
//         ),
//       ],
//     ),
//   ),
// ),


// SizedBox(
//   width: double.infinity,
//   height: double.infinity,
//   child: Stack(
//     alignment: Alignment.center,
//     children: [
//       const Positioned(
//         top: 50,
//         child: Image(
//           height: 120,
//           width: 120,
//           image: AssetImage(
//             "assets/images/walk.png",
//           ),
//         ),
//       ),
//       Container(
//         height: Screen.height(context: context),
//         width: Screen.width(context: context),
//         padding:
//             const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 height: Screen.height(context: context) * 0.32,
//               ),
//               const Text(
//                 '${AppString.otpPage}',
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(
//                 height: Screen.height(context: context) * 0.01,
//               ),
//               // Text(
//               //   '${AppString.pleaseEnterOtp}\n${widget.phoneNumber}',
//               //   style: const TextStyle(
//               //     color: Colors.black,
//               //     fontSize: 18,
//               //   ),
//               //   textAlign: TextAlign.center,
//               // ),
//               SizedBox(
//                 height: Screen.height(context: context) * 0.05,
//               ),
//               Pinput(
//                 length: 6,
//                 controller: _otpController,
//               ),
//               SizedBox(
//                 height: Screen.height(context: context) * 0.1,
//               ),
//               RoundedLoadingButton(
//                 controller: _buttonController,
//                 animateOnTap: false,
//                 color: AppColor.greenDarkColor,
//                 successColor: AppColor.greenDarkColor,
//                 onPressed: () async {
//                   count++;
//                   if (count < 4) {
//                     if (_otpController.text.length == 6) {
//                       PhoneAuthCredential credential =
//                           PhoneAuthProvider.credential(
//                               verificationId: widget.verificationId,
//                               smsCode: _otpController.text);
//                       await FirebaseAuth.instance
//                           .signInWithCredential(credential);
//                       // ignore: use_build_context_synchronously
//                       Go.pushAndRemoveUntil(
//                           context: context,
//                           pushReplacement: RevisedHomePage(
//                               isLoggedIn: (){}, logOut: (){}));
//                       // widget.isSignIn
//                       //     ? await AWSAuth
//                       //         .confirmSignInPhoneVerification(
//                       //         _otpController.text,
//                       //         context,
//                       //         widget.isLoggedIn,
//                       //         widget.logOut,
//                       //       )
//                       //     : await AWSAuth
//                       //         .confirmSignUpPhoneVerification(
//                       //             widget.phoneNumber,
//                       //             _otpController.text,
//                       //             widget.isLoggedIn,
//                       //             widget.logOut,
//                       //             context);
//                     } else {
//                       _buttonController.error();
//                       Timer(const Duration(seconds: 2), () {
//                         _buttonController.reset();
//                       });
//                     }
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text(
//                             'Attempt exceeded, Please request new OTP'),
//                       ),
//                     );
//                   }
//                 },
//                 child: const Text(
//                   AppString.verifyOtp,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 2,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: Screen.height(context: context) * 0.1,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const Text(
//                     AppString.otpNotReceived,
//                     style: TextStyle(
//                         color: Colors.black45,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w300),
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       if (count > 3) {
//                         // count = 0;
//                         // widget.isSignIn
//                         //     ? await AWSAuth.signInWithPhoneVerification(
//                         //         widget.phoneNumber,
//                         //         "password",
//                         //         context,
//                         //         widget.isSignIn,
//                         //         widget.isLoggedIn,
//                         //         widget.logOut)
//                         //     : await AWSAuth.signUpWithPhoneVerification(
//                         //         widget.phoneNumber,
//                         //         "password",
//                         //         context,
//                         //         widget.isSignIn,
//                         //         widget.isLoggedIn,
//                         //         widget.logOut);
//                         // Fluttertoast.showToast(
//                         //   msg: "OTP Resent",
//                         // );
//                       }
//                     },
//                     child: const Text(
//                       AppString.resendOtp,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       )
//     ],
//   ),
// ),
