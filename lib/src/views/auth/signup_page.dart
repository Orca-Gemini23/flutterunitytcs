import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/auth_controller.dart';
import 'package:walk/src/widgets/textfields.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();

  String _selectedGender = "Male";
  List<String> gender = ["Male", "Female"];

  @override
  void dispose() {
    _fullnameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          AppString.signUpPageTitle,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getTextfield("Full Name", _fullnameController, Icons.person),
              getTextfield("Email", _emailController, Icons.mail),
              getTextfield("Age", _ageController, Icons.numbers),
              Container(
                padding: const EdgeInsets.only(right: 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff005749),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      AppString.gender,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    Radio(
                      value: AppString.male,
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {});
                        _selectedGender = value!;
                      },
                    ),
                    const Text(
                      AppString.male,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Radio(
                      value: AppString.female,
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {});
                        _selectedGender = value!;
                      },
                    ),
                    const Text(
                      AppString.female,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              getTextfield("Phone", _phoneController, Icons.phone),
              getTextfield("City", _cityController, Icons.location_city),
              const Spacer(),
              Consumer<AuthController>(
                builder: (context, controller, widget) {
                  return RoundedLoadingButton(
                    animateOnTap: false,
                    color: AppColor.greenDarkColor,
                    width: double.maxFinite,
                    successColor: AppColor.greenDarkColor,
                    height: 60,
                    loaderSize: 25,
                    controller: _buttonController,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _buttonController.start();
                        bool isRegistered = await controller.registerUser(
                            _fullnameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _cityController.text,
                            _selectedGender,
                            _ageController.text);

                        log(isRegistered.toString());

                        if (isRegistered) {
                          ////After registration is successful take the user to login page. And let the user login
                          _buttonController.success();
                          Navigator.pop(context);
                        } else {
                          print("coming herer");
                          _buttonController.error();
                          Timer(
                              const Duration(
                                seconds: 3,
                              ), () {
                            _buttonController.reset();
                          });
                        }
                      }
                    },
                    child: const Text(
                      AppString.register,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
