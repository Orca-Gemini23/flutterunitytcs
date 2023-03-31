import 'package:flutter/material.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/widgets/textfields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset("assets/images/dottedbackground.png"),
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
                    getTextfield("Email", _emailController, Icons.mail),
                    getTextfield("Password", _passwordController, Icons.lock),
                    SizedBox(
                      height: Screen.height(context: context) * 0.1,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        minimumSize: const Size(180, 50),
                        side: const BorderSide(
                            color: Color(0xff005749), width: 3),
                        backgroundColor: Colors.white,
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Screen.height(context: context) * 0.1,
                    ),
                    const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
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
