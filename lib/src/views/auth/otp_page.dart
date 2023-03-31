import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/widgets/textfields.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _phoneController = TextEditingController();

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
                child: Image.asset("assets/images/dottedbackground.png"),
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
                        "OTP Verification",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: Screen.height(context: context) * 0.05,
                      ),
                      const Text(
                        "Please enter the OTP\nsent to [phoneNumber]",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: Screen.height(context: context) * 0.05,
                      ),
                      const Pinput(),
                      SizedBox(
                        height: Screen.height(context: context) * 0.1,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          //add checks and submit details
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
                          "VERIFY",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Screen.height(context: context) * 0.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "OTP not received?",
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 18,
                                fontWeight: FontWeight.w300),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "RESEND",
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
