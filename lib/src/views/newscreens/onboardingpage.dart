import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:walk/src/views/auth/phone_auth.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const PhoneAuthPage(),
      ),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/images/gif.webp',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(0, 87, 73, 1),
    minimumSize: const Size(double.maxFinite, 60),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);

    const pageDecoration = PageDecoration(
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
    );

    // final ButtonStyle style =
    //     ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/tour/Group 164.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: newMethod(context, pageDecoration),
    );
  }

  IntroductionScreen newMethod(
      BuildContext context, PageDecoration pageDecoration) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.transparent,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      globalFooter: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: raisedButtonStyle,
                child: const Text(
                  'Get started',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
                onPressed: () => _onIntroEnd(context),
              ),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Already have a account ? ",
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                    text: "Sign in",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        //
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      pages: [
        PageViewModel(
          title: "",
          body: "Get moving and Beat freezing",
          decoration: pageDecoration.copyWith(
            fullScreen: true,
            bodyFlex: 1,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Beat Parkinson's one step at a time",
          decoration: pageDecoration.copyWith(
            fullScreen: true,
            bodyFlex: 1,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Better balance and coordination",
          decoration: pageDecoration.copyWith(
            fullScreen: true,
            bodyFlex: 1,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
      ],
      showSkipButton: false,
      showBackButton: false,
      showNextButton: false,
      showDoneButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      back: const Icon(Icons.arrow_back),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
      ),
    );
  }
}
