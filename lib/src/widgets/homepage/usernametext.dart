import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/db/local_db.dart';

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
            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w700),
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
                    : '${userBox.get(0, defaultValue: LocalDB.defaultUser)!.name}!',
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

class UserNameImage extends StatelessWidget {
  const UserNameImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<UserModel>>(
        valueListenable: LocalDB.listenableUser(),
        builder: (context, userBox, child) {
          return CircleAvatar(
            //Show default user icon if there is no image selected
            backgroundImage:
                userBox.get(0, defaultValue: LocalDB.defaultUser)!.image == "NA"
                    ? const AssetImage("assets/images/defaultuser.png")
                    : FileImage(
                        File(userBox
                            .get(0, defaultValue: LocalDB.defaultUser)!
                            .image),
                      ) as ImageProvider<Object>,
            backgroundColor: AppColor.greenDarkColor,
          );
        });
  }
}
