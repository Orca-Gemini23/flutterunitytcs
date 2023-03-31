import 'package:flutter/material.dart';
import 'package:walk/src/widgets/textfields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
            Positioned(
              top: 300,
              child: getTextfield("sdfsdfsdf", _emailController, Icons.person),
            )
          ],
        ),
      ),
    );
  }
}
