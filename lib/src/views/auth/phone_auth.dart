import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/utils/custom_navigation.dart';
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
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Phone AuthPage')
        .then(
          (value) => debugPrint("Analytics stated"),
        );
    super.initState();
  }


  var country = countries.firstWhere((element) => element.code == 'IN');


  bool isButton = false;


  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    disabledBackgroundColor:Colors.grey,
    backgroundColor: const Color.fromRGBO(0, 87, 73, 1),
    minimumSize: const Size(double.maxFinite, 60),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  );


  final TextEditingController numberController = TextEditingController();


  Future<void> openUrl(String url) async {
    final _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
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
        // leading: IconButton(
        //   icon: const Icon(
        //       Icons.arrow_back_ios), // Different icon for back button
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
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
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 24, fontFamily:"Helvetica"),
                      ),
                      const Text(
                        "What’s your number?",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 24, fontFamily:"Helvetica"),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "We’ll send you a code to verify your phone.",
                      style:
                          TextStyle(fontWeight: FontWeight.lerp(FontWeight.w400, FontWeight.w500, 0.5), fontSize: 14, fontFamily:"Helvetica"),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 48,
              ),
              const Text(
                "Phone Number",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14,fontFamily:"Helvetica"),
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
                  hintStyle: TextStyle(fontFamily:"Helvetica", fontSize: 14, fontWeight: FontWeight.w400),
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
                  Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text.rich(
                  style:
                      const TextStyle(fontWeight: FontWeight.w400, fontSize: 9, fontFamily:"Helvetica"),
                      TextSpan(
                        children: [
                          const TextSpan(text: "By signing up you accept our "),
                          TextSpan(
                            text: "terms of service",
                        style: const TextStyle(color: Color(0xFF2DBA9B)),//decoration: TextDecoration.underline
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                            openUrl('https://www.lifesparktech.com/terms-and-conditions');
                              },
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "privacy policy",
                        style: const TextStyle(color: Color(0xFF2DBA9B)),//decoration: TextDecoration.underline
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                            openUrl('https://www.lifesparktech.com/privacy-policy');
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
                                  Fluttertoast.showToast(msg: e.toString());
                                  setState(() {
                                    loading = false;
                                  });
                                },
                    codeSent: (String verificationId, int? resendToken) {
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
                            codeAutoRetrievalTimeout: (String verificationId) {
                                  verificationId = _verificationId;
                                },
                              );
                            }
                          : null,
                      child: !loading
                          ? const Text(
                              'Continue',
                              style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16, fontFamily:"Helvetica"),
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




// body: SizedBox(
//   width: double.infinity,
//   height: double.infinity,
//   child: Stack(
//     alignment: Alignment.center,
//     children: [
//       Positioned(
//         top: -140,
//         left: -140,
//         child: Image.asset(AppAssets.backgroundImage),
//       ),
//       Container(
//         height: Screen.height(context: context),
//         width: Screen.width(context: context),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 height: Screen.height(context: context) * 0.45,
//               ),
//               const Text(
//                 AppString.enterNumber,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//               SizedBox(
//                 height: Screen.height(context: context) * 0.05,
//               ),
//               IntlPhoneField(
//                 decoration: const InputDecoration(
//                   // labelText: 'Phone Number',
//                   suffixIcon: Icon(Icons.phone_android),
//                 ),
//                 initialCountryCode: 'IN',
//                 showDropdownIcon: false,
//                 showCountryFlag: false,
//                 keyboardType: const TextInputType.numberWithOptions(
//                     signed: true, decimal: true),
//                 onChanged: (phone) {
//                   // print(phone.completeNumber);
//                   phoneNumber = phone.completeNumber;
//                   countryCode = phone.countryCode;
//                   phoneNo = phone.number;
//                 },
//               ),
//               // getTextfield(
//               //     "Enter Number", _phoneController, Icons.phone_android),
//               SizedBox(
//                 height: Screen.height(context: context) * 0.1,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   print(phoneNumber);
//                   var newUser = UserModel(
//                     name: "Unknown User",
//                     age: "XX",
//                     phone: "$countryCode $phoneNo",
//                     image: "NA",
//                     gender: "XX",
//                     address: "XX",
//                     email: "XX",
//                   );


//                   LocalDB.saveUser(newUser);
//                   //add checks and submit details
//                   // Go.to(
//                   //   context: context,
//                   //   push: OTPPage(
//                   //     phoneNumber: phoneNumber,
//                   //     isSignIn: widget.isSignIn,
//                   //   ),
//                   // );
//                   // widget.isSignIn
//                   //     ? await AWSAuth.signInWithPhoneVerification(
//                   //         phoneNumber,
//                   //         "password",
//                   //         context,
//                   //         widget.isSignIn,
//                   //         widget.isLoggedIn,
//                   //         widget.logOut)
//                   //     : await AWSAuth.signUpWithPhoneVerification(
//                   //         phoneNumber,
//                   //         "password",
//                   //         context,
//                   //         widget.isSignIn,
//                   //         widget.isLoggedIn,
//                   //         widget.logOut);
//                   await FirebaseAuth.instance.verifyPhoneNumber(
//                     phoneNumber: phoneNumber,
//                     verificationCompleted:
//                         (PhoneAuthCredential credential) async {},
//                     verificationFailed: (FirebaseAuthException e) {
//                       print(e);
//                     },
//                     codeSent: (String verificationId, int? resendToken) {
//                       print("hello");
//                       Go.pushReplacement(
//                         context: context,
//                         pushReplacement: OTPPage(
//                           verificationId: verificationId,
//                           resendToken: resendToken,
//                         ),
//                       );
//                     },
//                     codeAutoRetrievalTimeout: (String verificationId) {},
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 10, horizontal: 30),
//                   fixedSize: const Size(200, 50),
//                   backgroundColor: const Color(0xff005749),
//                   elevation: 7,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                 ),
//                 child: const Text(
//                   AppString.sendOtp,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//     ],
//   ),
// ),

