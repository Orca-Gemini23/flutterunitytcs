import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/user_controller.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var userContoller = Provider.of<UserController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Need Help?',
          style: TextStyle(
            color: AppColor.greenDarkColor,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
          color: AppColor.blackColor,
        ),
        elevation: 0,
        backgroundColor: AppColor.whiteColor,
      ),
      body: ListView(
        children: List.generate(
          3,
          (index) {
            return Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColor.greenDarkColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.help,
                  color: AppColor.whiteColor,
                ),
                title: Text(
                  userContoller.helpNavListTIle.keys.elementAt(index),
                  style: const TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  userContoller.helpNavListTIle.values.elementAt(index),
                  style: const TextStyle(
                    color: AppColor.greyLight,
                  ),
                ),
                onTap: () => userContoller.helpNavigation(index, context),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColor.whiteColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
