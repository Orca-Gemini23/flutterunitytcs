import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/utils/awshelper.dart/awsauth.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/views/auth/otp_page.dart';

import '../../constants/app_color.dart';

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
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      disabledBackgroundColor: Colors.grey,
      backgroundColor: Color.fromRGBO(0, 87, 73, 1),
      minimumSize: Size(double.maxFinite, 60),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );

    const _initialCountryCode = 'IN';
    var _country =
        countries.firstWhere((element) => element.code == _initialCountryCode);

    bool isButton = false;

    // AWSAuth.fetchAuthSession();
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Let’s get started.",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                ),
                Text(
                  "what’s your number?",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "We’ll send you a code to verify your phone.",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 51,
            ),
            Text(
              "Phone Number",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
            SizedBox(
              height: 12,
            ),
            IntlPhoneField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                counterText: '',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'IN',
              showDropdownIcon: false,
              showCountryFlag: false,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              onChanged: (phone) {
                // if (phone.number.length >= _country.minLength &&
                //     phone.number.length <= _country.maxLength) {
                //   setState(() {
                //     print("reached here");
                //     isButton = true;
                //   });
                // }
                phoneNumber = phone.completeNumber;
                countryCode = phone.countryCode;
                phoneNo = phone.number;
              },
              onCountryChanged: (country) => _country = country,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'By signing up you accept our terms of service and privacy policy',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 9),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: phoneNumber,
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {},
                      verificationFailed: (FirebaseAuthException e) {
                        print(e);
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        Go.to(
                          context: context,
                          push: OTPPage(
                            verificationId: verificationId,
                            resendToken: resendToken,
                          ),
                        );
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  )),
            )
          ],
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