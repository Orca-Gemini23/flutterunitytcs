import 'package:flutter/material.dart';
import 'package:walk/widgets/textfields.dart';

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
          "Create Account",
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
              padding: EdgeInsets.only(right: 20),
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
                    "Gender",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Spacer(),
                  Radio(
                    value: "Male",
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {});
                      _selectedGender = value!;
                    },
                  ),
                  const Text(
                    "Male",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Radio(
                    value: "Female",
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {});
                      _selectedGender = value!;
                    },
                  ),
                  const Text(
                    "Female",
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
            ElevatedButton(
              onPressed: () {
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
                "NEXT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
