import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/user_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    var userContoller = Provider.of<UserController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppString.accountTitle,
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
            Go.back(context: context);
          }),
        ),
        centerTitle: false,
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppColor.greenDarkColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              leading: Icon(
                userContoller.accountTileIcon[index],
                color: AppColor.whiteColor,
                size: 30,
              ),
              title: Text(
                userContoller.accountNavigationTile.keys.elementAt(index),
                style: const TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                userContoller.accountNavigationTile.values.elementAt(index),
                style: const TextStyle(
                  color: AppColor.greyLight,
                ),
              ),
              onTap: () => userContoller.accountNavigation(index, context),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColor.whiteColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
