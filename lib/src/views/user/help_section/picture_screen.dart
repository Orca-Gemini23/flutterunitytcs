import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/user_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';

class PicturePage extends StatelessWidget {
  const PicturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Picture',
          style: TextStyle(
            color: AppColor.greenDarkColor,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => Go.back(context: context),
          icon: const Icon(Icons.arrow_back),
          color: AppColor.blackColor,
        ),
        elevation: 0,
        backgroundColor: AppColor.whiteColor,
      ),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.all(10),
                  width: Screen.width(context: context) - 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.greenDarkColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: userController.images.isEmpty
                      ? TextButton(
                          onPressed: userController.pickImage,
                          child: const Text(
                            'Select Image..',
                          ),
                        )
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: Screen.height(context: context) / 2.3,
                              width: Screen.width(context: context) - 20,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3, mainAxisExtent: 150),
                                itemCount: userController.images.length,
                                itemBuilder: (context, index) {
                                  var image = userController.images[index];
                                  return InkWell(
                                    onTap: () {
                                      photoViewer(
                                          userController.images[index].path,
                                          context);
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Image.file(
                                          image,
                                          height: 90,
                                          width: 90,
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: () =>
                                              userController.deleteImage(index),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: AppColor.greenDarkColor,
                                          ),
                                          label: const Text(
                                            'Delete',
                                            style: TextStyle(
                                                color: AppColor.greenDarkColor),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                              color: AppColor.greenDarkColor,
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 0, 4, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: userController.pickImage,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              ),
                              child: const Text(
                                'Select Image..',
                              ),
                            ),
                          ],
                        ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.all(10),
                  width: Screen.width(context: context) - 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.greenDarkColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: userController.video == null
                      ? TextButton(
                          onPressed: userController.pickVideo,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          ),
                          child: const Text(
                            'Select Video..',
                          ),
                        )
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: Screen.height(context: context) / 2.3,
                              width: Screen.width(context: context) - 20,
                              child: InkWell(
                                onTap: () {
                                  // photoViewer(image.path, context);
                                },
                                child: Column(
                                  children: <Widget>[
                                    userController.video == null
                                        ? const Center()
                                        : SizedBox(
                                            height: 150,
                                            width:
                                                Screen.width(context: context) -
                                                    40,
                                            child: AspectRatio(
                                              aspectRatio: userController
                                                  .videoController
                                                  .value
                                                  .aspectRatio,
                                              child: VideoPlayer(userController
                                                  .videoController),
                                            ),
                                          ),
                                    OutlinedButton.icon(
                                      onPressed: userController.deleteVideo,
                                      icon: const Icon(
                                        Icons.delete,
                                        color: AppColor.greenDarkColor,
                                      ),
                                      label: const Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: AppColor.greenDarkColor),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: AppColor.greenDarkColor,
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 0, 4, 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: userController.pickImage,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              ),
                              child: const Text(
                                'Select Image..',
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
        child: FloatingActionButton.extended(
          onPressed: null,
          label: Text(
            'Send selected media',
            style: TextStyle(
              color: AppColor.whiteColor,
            ),
          ),
          backgroundColor: AppColor.greenDarkColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  photoViewer(String name, BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Color.fromARGB(52, 255, 255, 255),
      builder: (context) => Container(
        width: Screen.width(context: context),
        child: PhotoView(imageProvider: AssetImage(name)),
      ),
    );
  }
}
