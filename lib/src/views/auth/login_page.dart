// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/auth_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';
// import 'package:walk/src/views/auth/otp_page.dart';
import 'package:walk/src/views/auth/signup_page.dart';

import 'package:walk/src/widgets/textfields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.isSignIn});

  final bool isSignIn;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _buttonController.reset();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              top: 50,
              child: Image(
                height: 120,
                width: 120,
                image: AssetImage("assets/images/walk.png"),
              ),
            ),
            const Positioned(
                top: 200,
                left: 10,
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            Container(
              height: Screen.height(context: context),
              width: Screen.width(context: context),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: Screen.height(context: context) * 0.45,
                      ),
                      getTextfield("Email", _emailController, Icons.mail),
                      // getTextfield("Password", _passwordController, Icons.lock),
                      SizedBox(
                        height: Screen.height(context: context) * 0.1,
                      ),
                      Consumer<AuthController>(
                        builder: (context, authController, child) {
                          return RoundedLoadingButton(
                            animateOnTap: false,
                            controller: _buttonController,
                            color: AppColor.greenDarkColor,
                            successColor: AppColor.greenDarkColor,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _buttonController.start();
                                bool otpSent = await authController
                                    .sendOtp(_emailController.text);
                                if (otpSent) {
                                  _buttonController.success();
                                  _buttonController.reset();
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) {
                                  //       return OTPPage(
                                  //         email: _emailController.text,
                                  //       );
                                  //     },
                                  //   ),
                                  // );
                                } else {
                                  _buttonController.error();
                                  Timer(const Duration(seconds: 2), () {
                                    _buttonController.reset();
                                  });
                                }
                              }
                            },
                            child: const Text(
                              AppString.sendOtp,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: Screen.height(context: context) * 0.1,
                      ),
                      InkWell(
                        onTap: () {
                          Go.to(
                            context: context,
                            push: const SignupPage(),
                          );
                        },
                        child: const Text(
                          "New here ? Try signing up first ",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
