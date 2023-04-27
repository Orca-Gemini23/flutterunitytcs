import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

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
            Consumer<AuthController>(builder: (context, controller, widget) {
              return ElevatedButton(
                onPressed: () async {
                  bool isRegistered = await controller.registerUser(
                      _fullnameController.text,
                      _emailController.text,
                      _phoneController.text,
                      _cityController.text,
                      _selectedGender,
                      _ageController.text);
                  if (isRegistered) {
                    Navigator.pop(context);
                  }
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
                  AppString.register,
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
