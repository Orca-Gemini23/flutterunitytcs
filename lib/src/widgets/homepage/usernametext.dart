import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/utils/firebasehelper/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';

import '../../models/user_model.dart';

class UsernameText extends StatelessWidget {
  const UsernameText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<UserModel>>(
      valueListenable: LocalDB.listenableUser(),
      builder: (contex, userBox, child) {
        return RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: DeviceSize.isTablet ? 30.h : 30.sp,
                fontWeight: FontWeight.w700),
            children: <TextSpan>[
              const TextSpan(
                text: 'Hello, ',
                style: TextStyle(
                  color: AppColor.greenDarkColor,
                ),
              ),
              TextSpan(
                text: userBox.get(0, defaultValue: LocalDB.defaultUser)!.name ==
                        "Unknown User"
                    ? ""
                    : userBox
                            .get(0, defaultValue: LocalDB.defaultUser)!
                            .name
                            .contains(" ")
                        ? '${userBox.get(0, defaultValue: LocalDB.defaultUser)!.name.substring(0, userBox.get(0, defaultValue: LocalDB.defaultUser)!.name.indexOf(' '))}!'
                        : userBox
                            .get(0, defaultValue: LocalDB.defaultUser)!
                            .name,
                style: const TextStyle(
                  color: AppColor.gameEntryTileColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UserNameImage extends StatefulWidget {
  const UserNameImage({
    super.key,
  });

  @override
  State<UserNameImage> createState() => _UserNameImageState();
}

class _UserNameImageState extends State<UserNameImage> {
  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        ImagePath.path = pickedFile.path;
        PreferenceController.saveStringData("profileImage", pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<UserModel>>(
        valueListenable: LocalDB.listenableUser(),
        builder: (context, userBox, child) {
          return GestureDetector(
            onTap: () {
              Analytics.addClicks("ProfilePicPicker", DateTime.timestamp());
              _pickImage();
            },
            child: CircleAvatar(
              radius: DeviceSize.isTablet ? 60 : 30,
              backgroundImage: ImagePath.path == ""
                  ? const AssetImage("assets/images/defaultuser.png")
                  : FileImage(
                      File(ImagePath.path),
                    ) as ImageProvider<Object>,
              backgroundColor: AppColor.greenDarkColor,
            ),
          );
        });
  }
}
