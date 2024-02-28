import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppString.contactUsPageTitle,
          style: TextStyle(
            color: AppColor.greenDarkColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.blackColor,
          ),
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
        centerTitle: false,
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  AppString.org,
                  style: TextStyle(
                    fontSize: 42,
                    letterSpacing: 8,
                    color: AppColor.greenDarkColor,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 40,
                  padding: const EdgeInsets.all(0.5),
                  color: AppColor.greenDarkColor,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Lifespark\nTechnologies",
                  style: TextStyle(
                      color: AppColor.greenDarkColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(20.0, 10, 10, 10),
              height: 60,
              color: AppColor.greenDarkColor,
              child: const Text(
                AppString.knowMore,
                style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              AppString.beInContact,
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.email,
                  color: AppColor.greenDarkColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () async {
                    final Uri launchUri = Uri(
                      scheme: 'mailto',
                      path: 'info@lifesparktech.com',
                    );
                    await launchUrl(launchUri);
                  },
                  child: const Text(
                    "info@lifesparktech.com",
                    style: TextStyle(
                      color: AppColor.blackColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    String contact = '+919324730665';
                    var androidUrl =
                        "whatsapp://send?phone=$contact&text=Hi, [user] here";
                    var iosUrl =
                        "https://wa.me/$contact?text=${Uri.parse('Hi, [user] here')}";

                    try {
                      if (Platform.isIOS) {
                        await launchUrl(Uri.parse(iosUrl));
                      } else {
                        await launchUrl(Uri.parse(androidUrl));
                      }
                    } catch (e) {
                      log('Whatsapp function error: $e');
                    }
                  },
                  child: Image.asset(
                    AppAssets.whatsappIcon,
                    height: 26,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.phone,
                  color: AppColor.greenDarkColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: '+919324730665',
                    );
                    await launchUrl(launchUri);
                  },
                  child: const Text(
                    "+91 919324730665",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            const Text(
              AppString.weAreAvailable,
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) {
                  List<String> socialMediaLogo = [
                    AppAssets.instagramIcon,
                    AppAssets.facebookIcon,
                    AppAssets.twitterIcon,
                  ];
                  List<Function()?> logoOnTap = [
                    () async {
                      final Uri launchUri =
                          Uri.parse('https://instagram.com/username');
                      await launchUrl(launchUri);
                    },
                    () async {
                      final Uri launchUri =
                          Uri.parse('https://facebook.com/username');
                      await launchUrl(launchUri);
                    },
                    () async {
                      final Uri launchUri =
                          Uri.parse('https://twitter.com/username');
                      await launchUrl(launchUri);
                    },
                  ];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: logoOnTap[index],
                      child: Image.asset(
                        socialMediaLogo[index],
                        height: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
