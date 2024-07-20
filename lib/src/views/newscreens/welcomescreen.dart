import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/utils/custom_navigation.dart';
// import 'package:walk/src/views/newscreens/instructions.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(0, 87, 73, 1),
    minimumSize: const Size(double.maxFinite, 60),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back_ios), // Different icon for back button
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Hi, ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: '${LocalDB.user!.name}!',
                    style: const TextStyle(
                      color: Color(0xFF2DBA9B),
                    ),
                  ),
                ],
              ),
            ),
            // Text(
            //   "Hi, ${LocalDB.user!.name}!",
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            //   textAlign: TextAlign.center,
            // ),
            const Text(
              "Welcome to the Lifespark family",
              // maxLines: 2,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Let’s set up your device ",
              // maxLines: 2,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 57,
            ),
            Image.asset('assets/images/Character-1.png'),
            const Spacer(),
            ElevatedButton(
              style: elevatedButtonStyle,
              onPressed: () async {
                // Go.to(context: context, push: const Instuctions());
              },
              child: const Text(
                'Continue',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
