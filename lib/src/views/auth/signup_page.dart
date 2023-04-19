import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/auth_controller.dart';
import 'package:walk/src/widgets/textfields.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  String _selectedGender = "Male";
  List<String> gender = ["Male", "Female"];
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getTextfield("First Name", _firstnameController, Icons.person),
            getTextfield("Last Name", _lastnameController, Icons.person),
            getTextfield("Email", _emailController, Icons.mail),
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
            getTextfield("Password", _passwordController, Icons.lock),
            getTextfield(
                "Confirm Password", _confirmpasswordController, Icons.lock),
            const Spacer(),
            Consumer<AuthController>(builder: (context, controller, widget) {
              return ElevatedButton(
                onPressed: () {
                  // print(_firstnameController.text);
                  // print(_lastnameController.text);
                  // print(_emailController.text);
                  // print(_selectedGender[0]);
                  // print(_cityController.text);
                  // print(_passwordController.text);

                  // await controller.registerUser(
                  //   _firstnameController.text,
                  //   _lastnameController.text,
                  //   _emailController.text,
                  //   _phoneController.text,
                  //   _cityController.text,
                  //   _selectedGender[0],
                  //   _passwordController.text,
                  // );

                  //add checks and submit details
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  minimumSize: const Size(180, 50),
                  backgroundColor: const Color(0xff005749),
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text(
                  AppString.nextPage,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
