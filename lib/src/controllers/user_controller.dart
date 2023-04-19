import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/user/help_section/debug_walk.dart';
import 'package:walk/src/views/user/help_section/picture_screen.dart';
import 'package:walk/src/views/user/help_section/raise_ticket.dart';

class UserController extends ChangeNotifier {
  // UserController() {
  //   videoController = VideoPlayerController.file(video?);
  // }

  /// Initialising controller for video player
  late VideoPlayerController videoController;

  /// Initialising image picker instance
  final ImagePicker imagePicker = ImagePicker();

  /// List of images picked from gallery
  List<File> images = [];

  /// Video picked from gallery
  File? video;

  /// Raise Ticket expansionPanelList on expansionCallBack
  void onExpansionCallBack(int index, bool isExpanded) {
    try {
      // ticketQueryQuestion.entries.elementAt(index).value = isExpanded;
      ticketQueryQuestion.update(
          ticketQueryQuestion.keys.elementAt(index), (value) => isExpanded);
      notifyListeners();
    } catch (e) {
      log('Raise ticket onExpansionCallBack error: $e');
    } finally {}
  }

  /// Help main screen navigation function
  void helpNavigation(int index, BuildContext context) {
    try {
      switch (index) {
        case 0:
          Go.to(context: context, push: const RaiseTicketPage());

          break;

        case 1:
          Go.to(context: context, push: const PicturePage());

          break;
        case 2:
          Go.to(context: context, push: const DebugWalkPage());

          break;
        default:
      }
    } catch (e) {
      log('help Nav function error: $e');
    }
  }

  /// Pick an image from gallery
  void pickImage({bool add = false}) async {
    try {
      var pics = await imagePicker.pickMultiImage();
      // ignore: unnecessary_null_comparison
      if (pics.isNotEmpty && pics != null) {
        if (add) {
          for (var element in pics) {
            File f = File(element.path);
            images.add(f);
          }
        } else {
          images = pics.map((e) => File(e.path)).toList();
        }
      }
      notifyListeners();
    } catch (e) {
      log('pickImage func error: $e');
      notifyListeners();
    }
  }

  /// Pick videos from gallery
  void pickVideo() async {
    try {
      var vid = await imagePicker.pickVideo(source: ImageSource.gallery);
      if (vid != null) {
        video = File(vid.path);
        videoController = VideoPlayerController.file(video!);
      }
      notifyListeners();
    } catch (e) {
      log('pickVideo func error: $e');
      notifyListeners();
    }
  }

  /// Opens camera for taking pics
  void openCamera() async {
    try {
      var pics = await imagePicker.pickImage(source: ImageSource.camera);
      if (pics != null) {
        images.add(File(pics.path));
      } else {
        log('not captured any image or video');
      }

      notifyListeners();
    } catch (e) {
      log('Capture image func error: $e');
      notifyListeners();
    }
  }

  /// Delete images from list
  void deleteImage(int index) async {
    try {
      images.removeAt(index);
      notifyListeners();
    } catch (e) {
      log('Deleting image from list error: $e');
    }
  }

  /// Delete selected video
  void deleteVideo() {
    try {
      video = null;
      notifyListeners();
    } catch (e) {
      log('Deleting video erro: $e');
    }
  }

  /// Map of raised tickets tile and its expanded value
  Map<String, bool> ticketQueryQuestion = {
    'Select the issues you are facing from the dropdown': false,
    'User related issues': false
  };

  /// List of navigation in help page
  Map<String, String> helpNavListTIle = {
    'Raise a ticket': 'Facing any issue?',
    'Send picture': 'Help us by sending a picture of any problem.',
    'Debug WALK Device': 'Solve issue regarding the WALK device.',
  };
  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }
}
