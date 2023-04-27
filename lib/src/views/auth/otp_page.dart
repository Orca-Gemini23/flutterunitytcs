import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/auth_controller.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/views/auth/signup_page.dart';
import 'package:walk/src/views/home_page.dart';

class OTPPage extends StatefulWidget {
  OTPPage({super.key, required this.email});
  String email;
  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: Screen.height(context: context) * 0.32,
                      ),
                      const Text(
                        '${AppString.otpPage}[phoneNumber]',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: Screen.height(context: context) * 0.05,
                      ),
                      const Text(
                        AppString.pleaseEnterOtp,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: Screen.height(context: context) * 0.05,
                      ),
                      Pinput(
                        length: 6,
                        controller: _otpController,
                      ),
                      SizedBox(
                        height: Screen.height(context: context) * 0.1,
                      ),
                      Consumer<AuthController>(
                          builder: (context, authController, child) {
                        return ElevatedButton(
                          onPressed: () async {
                            bool otpVerified = await authController.verifyOtp(
                                widget.email, _otpController.text);
                            if (otpVerified) {
                              bool result =
                                  await PreferenceController.getboolData(
                                      showCaseKey);

                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Homepage(isShowCaseDone: result);
                                  },
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            fixedSize: const Size(180, 45),
                            backgroundColor: const Color(0xff005749),
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            AppString.verifyOtp,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: Screen.height(context: context) * 0.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            AppString.otpNotReceived,
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 18,
                                fontWeight: FontWeight.w300),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              AppString.resendOtp,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
