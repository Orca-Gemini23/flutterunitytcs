import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/user_model.dart';

class Revisedaccountpage extends StatefulWidget {
  const Revisedaccountpage({super.key});

  @override
  State<Revisedaccountpage> createState() => _RevisedaccountpageState();
}

class _RevisedaccountpageState extends State<Revisedaccountpage> {
  RegExp nameRegex = RegExp(r"^[a-zA-Z ]+$");
  RegExp numberRegex = RegExp(r"^\d+$");
  RegExp emailRegex = RegExp(r'\S+@\S+\.\S+');
  final TextEditingController nameController =
      TextEditingController(text: LocalDB.user!.name);
  final TextEditingController ageController =
      TextEditingController(text: LocalDB.user!.age);
  final TextEditingController genderController =
      TextEditingController(text: LocalDB.user!.gender);
  final TextEditingController cityController =
      TextEditingController(text: LocalDB.user!.address);
  final TextEditingController emailController =
      TextEditingController(text: LocalDB.user!.email);
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  File? _image;

  // Function to open the image picker and get the selected image
  Future<bool> _pickImage() async {
    bool result = false;
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Fluttertoast.showToast(msg: "Picture Updated");
        result = true;
      } else {
        result = false;
      }
    });
    return result;
  }

  @override
  void initState() {
    super.initState();
    if (LocalDB.user!.image != "NA") {
      _image = File(LocalDB.user!.image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: const Text(
          'My Account',
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: 19,
          ),
        ),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: const EdgeInsets.only(
          top: 100,
          left: 0,
          right: 0,
          bottom: 0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: AppColor.greenDarkColor,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : const AssetImage(
                          "assets/images/defaultuser.png",
                        ) as ImageProvider<Object>,
                  backgroundColor: AppColor.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () async {
                          // print(LocalDB.userBox().length);

                          // ///Total leng
                          // print(LocalDB.user!.name);

                          // ///0th index

                          // print(
                          //   LocalDB.userBox()
                          //       .get(LocalDB.userBox().length - 1)!
                          //       .name,
                          // );

                          // ///Latest index

                          bool result = await _pickImage();
                          if (result) {
                            log("image path selected ");
                            var updatedUser = UserModel(
                              name: nameController.text,
                              age: ageController.text,
                              phone: LocalDB.user!.phone,
                              image: _image?.path ?? "NA",
                              gender: genderController.text,
                              address: cityController.text,
                              email: emailController.text,
                            );
                            LocalDB.saveUser(updatedUser);
                          }
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColor.greenDarkColor,
                          child: Icon(
                            Icons.edit_outlined,
                            color: AppColor.whiteColor,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 35,
                    right: 35,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColor.lightgreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              nameRegex,
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            focusColor: AppColor.greenDarkColor,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: TextFormField(
                                controller: ageController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your age';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      numberRegex),
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Age',
                                  focusColor: AppColor.greenDarkColor,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextFormField(
                                controller: genderController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your gender ';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(nameRegex),
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Gender',
                                  focusColor: AppColor.greenDarkColor,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          controller: cityController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(nameRegex),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'City',
                            focusColor: AppColor.greenDarkColor,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            focusColor: AppColor.greenDarkColor,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        RoundedLoadingButton(
                          animateOnTap: true,
                          color: AppColor.greenDarkColor,
                          width: double.maxFinite,
                          curve: Curves.easeIn,
                          successColor: AppColor.greenDarkColor,
                          height: 60,
                          loaderSize: 25,
                          controller: _buttonController,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var newUser = UserModel(
                                name: nameController.text,
                                age: ageController.text,
                                phone: "",
                                image: _image?.path ?? "NA",
                                gender: genderController.text,
                                address: cityController.text,
                                email: emailController.text,
                              );

                              LocalDB.saveUser(newUser);

                              Timer(const Duration(seconds: 2), () {
                                _buttonController.success();
                              });
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
