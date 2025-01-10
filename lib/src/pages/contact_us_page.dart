import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/utils/global_variables.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: Text(
          AppString.contactUsPageTitle,
          style: TextStyle(
              color: AppColor.greenDarkColor,
              fontSize: DeviceSize.isTablet ? 36 : 20),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.blackColor,
            size: DeviceSize.isTablet ? 36 : 24,
          ),
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
        centerTitle: false,
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
                Text(
                  AppString.org,
                  style: TextStyle(
                      fontSize: DeviceSize.isTablet ? 84 : 42,
                      // letterSpacing: 4,
                      fontFamily: "Helvetica",
                      color: AppColor.greenDarkColor,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 10),
                Container(
                  height: DeviceSize.isTablet ? 80 : 40,
                  padding: const EdgeInsets.all(0.5),
                  color: AppColor.greenDarkColor,
                ),
                const SizedBox(width: 10),
                Text(
                  "Lifespark\nTechnologies",
                  style: TextStyle(
                      color: AppColor.greenDarkColor,
                      fontSize: DeviceSize.isTablet ? 36 : 18,
                      fontFamily: "Helvetica",
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(20.0, 10, 10, 10),
              height: DeviceSize.isTablet ? 90 : 60,
              color: AppColor.greenDarkColor,
              child: DeviceSize.isTablet
                  ? Text(
                      AppString.knowMore,
                      style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: DeviceSize.isTablet ? 32 : 18,
                          fontWeight: FontWeight.w300),
                    )
                  : Center(
                      child: Text(
                        AppString.knowMore,
                        style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: DeviceSize.isTablet ? 36 : 18,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                AppString.beInContact,
                style: TextStyle(
                  color: AppColor.blackColor,
                  fontSize: DeviceSize.isTablet ? 32 : 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: DeviceSize.isTablet ? 50 : 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: AppColor.greenDarkColor,
                  size: DeviceSize.isTablet ? 48 : 24,
                ),
                SizedBox(width: DeviceSize.isTablet ? 20 : 10),
                TextButton(
                  onPressed: () async {
                    final Uri launchUri = Uri(
                      scheme: 'mailto',
                      path: 'info@lifesparktech.com',
                    );
                    await launchUrl(launchUri);
                  },
                  child: Text(
                    "info@lifesparktech.com",
                    style: TextStyle(
                      color: AppColor.blackColor,
                      fontSize: DeviceSize.isTablet ? 32 : 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: DeviceSize.isTablet ? 25 : 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // InkWell(
                //   onTap: () async {
                //     String contact = '+919324730665';
                //     var androidUrl = "whatsapp://send?phone=$contact&text=";
                //     var iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";

                //     try {
                //       if (Platform.isIOS) {
                //         await launchUrl(Uri.parse(iosUrl));
                //       } else {
                //         await launchUrl(Uri.parse(androidUrl));
                //       }
                //     } catch (e) {
                //       log('Whatsapp function error: $e');
                //     }
                //   },
                //   child: Image.asset(
                //     AppAssets.whatsappIcon,
                //     height: DeviceSize.isTablet ? 52 : 26,
                //   ),
                // ),
                const SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.phone,
                  color: AppColor.greenDarkColor,
                  size: DeviceSize.isTablet ? 48 : 24,
                ),
                SizedBox(width: DeviceSize.isTablet ? 20 : 10),
                TextButton(
                  onPressed: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: '+919324730665',
                    );
                    await launchUrl(launchUri);
                  },
                  child: Text(
                    "+91 919324730665",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: DeviceSize.isTablet ? 32 : 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: DeviceSize.isTablet ? 50 : 35),
            Text(
              AppString.weAreAvailable,
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: DeviceSize.isTablet ? 32 : 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) {
                  List<String> socialMediaLogo = [
                    AppAssets.instagramIcon,
                    AppAssets.facebookIcon,
                    AppAssets.xIcon,
                    AppAssets.youtubeIcon,
                  ];
                  List<Function()?> logoOnTap = [
                    () async {
                      final Uri launchUri = Uri.parse(
                          'https://www.instagram.com/lifesparktechnologies/?hl=en');
                      await launchUrl(launchUri);
                    },
                    () async {
                      final Uri launchUri =
                          Uri.parse('https://www.facebook.com/lifesparktech/');
                      await launchUrl(launchUri);
                    },
                    () async {
                      final Uri launchUri = Uri.parse(
                          'https://x.com/i/flow/login?redirect_after_login=%2Flifesparktech');
                      await launchUrl(launchUri);
                    },
                    () async {
                      final Uri launchUri = Uri.parse(
                          'https://www.youtube.com/@lifesparktechnologies');
                      await launchUrl(launchUri);
                    },
                  ];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: logoOnTap[index],
                      child: Image.asset(
                        socialMediaLogo[index],
                        height: DeviceSize.isTablet ? 44 : 40,
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
