import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  // void _onIntroEnd(context) {
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (_) => const HomePage()),
  //   );
  // }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/images/gif.webp',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      imagePadding: EdgeInsets.zero,
    );

    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      globalFooter: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text(
                  'Get started',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                onPressed: () => {}, //_onIntroEnd(context),
              ),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: "Already have a account ? "),
                  TextSpan(
                    style: const TextStyle(color: Colors.black),
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
          body:
              "Instead of having to buy an entire share, invest any amount you want.",
          image: _buildFullscreenImage(),
          // _buildImage('img1.jpg'),
          // decoration: pageDecoration,
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "Learn as you go",
          body:
              "Download the Stockpile app and master the market with our mini-lesson.",
          image: _buildImage('img2.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Kids and teens",
          body:
              "Kids and teens can track their stocks 24/7 and place trades that you approve.",
          image: _buildImage('img3.jpg'),
          decoration: pageDecoration,
          reverse: true,
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
