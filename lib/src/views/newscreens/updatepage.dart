import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(0, 87, 73, 1),
    disabledBackgroundColor: Colors.grey,
    maximumSize: const Size(180, 60),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.only(
            bottom: 25,
            left: 35,
            right: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Visibility(
                visible: false,
                child: Text(
                  'Your Band\'s is up to date',
                  style: TextStyle(
                    color: AppColor.greenDarkColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Visibility(
                visible: true,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Update is Available',
                    style: TextStyle(
                      color: AppColor.greenDarkColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Image.asset('assets/images/updateillustration.png'),
              const Text(
                'Walk version: 15.0 \n Last successfully checked for update: \n 10.00 AM, 17 September 2024',
                style: TextStyle(fontSize: 16),
              ),
              const Divider(),
              const Visibility(
                visible: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What’s new in this update:',
                      style: TextStyle(
                        color: AppColor.greenDarkColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Improved performance for sleep tracking accuracy\n'
                      '• Bug fixes in Bluetooth connectivity\n'
                      '• Enhanced battery life estimation feature\n'
                      '• Security updates for enhanced data privacy',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {},
                  child: const Text(
                    'Check for update',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}
