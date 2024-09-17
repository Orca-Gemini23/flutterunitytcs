import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/firestoreusermodel.dart';
import 'package:walk/src/models/user_model.dart';

String country = "India";

class NewRevisedAccountPage extends StatefulWidget {
  const NewRevisedAccountPage({super.key});

  @override
  State<NewRevisedAccountPage> createState() => _RevisedaccountpageState();
}

class _RevisedaccountpageState extends State<NewRevisedAccountPage> {
  RegExp nameRegex = RegExp(r"^[a-zA-Z ]+$");
  RegExp numberRegex = RegExp(r"^\d+$");
  RegExp emailRegex = RegExp(r'\S+@\S+\.\S+');
  final TextEditingController nameController = TextEditingController(
      text: LocalDB.user!.name != "Unknown User" ? LocalDB.user!.name : "");
  final TextEditingController ageController = TextEditingController(
      text: LocalDB.user!.age != "XX" ? LocalDB.user!.age : "");
  // final TextEditingController genderController = TextEditingController(
  //     text: LocalDB.user!.gender != "XX" ? LocalDB.user!.gender : "");
  final TextEditingController cityController = TextEditingController(
      text: LocalDB.user!.address != "XX" ? LocalDB.user!.address : "");
  final TextEditingController emailController = TextEditingController(
      text: LocalDB.user!.email != "XX" ? LocalDB.user!.email : "");
  final TextEditingController phoneController =
      TextEditingController(text: LocalDB.user!.phone);
  TextEditingController heightController = TextEditingController(text: "");
  TextEditingController weightController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  // bool emailValid = false;
  // List<String> list = <String>['India', 'England'];
  // String selectedCountryCode = '+91';
  // Map<String, String> selecteCountryCode = {'India': '+91', 'England': '+44'};
  //  { '+91':'India', '+44':'England'};

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    disabledBackgroundColor: Colors.grey,
    backgroundColor: AppColor.greenDarkColor,
    minimumSize: const Size(double.maxFinite, 60),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  );

  final TextStyle textStyle = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
  );

  static final List<String> genders = ['Male', 'Female', 'Other'];
  String? selectedGender = (genders.contains(LocalDB.user!.gender))
      ? genders[genders.indexOf(LocalDB.user!.gender)]
      : null;

  // Function to open the image picker and get the selected image
  // Future<bool> _pickImage() async {
  //   bool result = false;
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? pickedFile =
  //       await picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       Fluttertoast.showToast(msg: "Picture Updated");
  //       result = true;
  //     } else {
  //       result = false;
  //     }
  //   });
  //   return result;
  // }

  @override
  void initState() {
    super.initState();
    if (LocalDB.user!.image != "NA") {
      // _image = File(LocalDB.user!.image);
    }
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Revised Account Page')
        .then(
          (value) => debugPrint("Analytics stated"),
        );
    PreferenceController.getstringData("Height").then((value) {
      setState(() {
        heightController = TextEditingController(text: value);
      });
    });
    PreferenceController.getstringData("Weight").then((value) {
      setState(() {
        weightController = TextEditingController(text: value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tell us about you !',
          style: TextStyle(
            color: AppColor.blackColor,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height * 0.9),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 24, bottom: 48, top: 24),
                child: Column(
                  children: [
                    // const Text(
                    //   'Tell us about you !',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w700,
                    //     fontSize: 24,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    // SizedBox(height: MediaQuery.sizeOf(context).height * 0.125),
                    Row(
                      children: [
                        CustomTextField(
                          fieldName: 'Name', //'First Name',
                          fieldHint: 'John Doe',
                          controller: nameController,
                          textStyle: textStyle,
                        ),
                        // SizedBox(width: 12),
                        // CustomTextField(
                        //   fieldName: 'Last Name',
                        //   fieldHint: 'Doe',
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTextField(
                            fieldName: 'Age',
                            fieldHint: '16',
                            controller: ageController,
                            textStyle: textStyle,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gender",
                                  style: textStyle,
                                ),
                                const SizedBox(height: 6),
                                InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.85),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      // alignment: AlignmentDirectional.bottomStart,
                                      hint: Text(
                                        'Gender',
                                        style: textStyle,
                                      ),
                                      value: selectedGender,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedGender = newValue;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      items: genders.map((String gender) {
                                        return DropdownMenuItem<String>(
                                          value: gender,
                                          child: Text(
                                            gender,
                                            style: textStyle,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          // CustomTextField(
                          //   fieldName: 'Gender',
                          //   fieldHint: 'male',
                          //   controller: genderController,
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CustomTextField(
                          fieldName: 'Address',
                          fieldHint: 'Mumbai',
                          controller: cityController,
                          textStyle: textStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          CustomTextField(
                            fieldName: 'Height(cm)',
                            fieldHint: '5\'7" or 170 cm ',
                            controller: heightController,
                            textStyle: textStyle,
                          ),
                          const SizedBox(width: 12),
                          CustomTextField(
                            fieldName: 'Weight(kg)',
                            fieldHint: '50 Kg',
                            controller: weightController,
                            textStyle: textStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CustomTextField(
                          fieldName: 'E-mail',
                          fieldHint: 'johndoe@email.com',
                          controller: emailController,
                          textStyle: textStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CustomTextField(
                          fieldName: 'Phone Number',
                          fieldHint: '(123) 456-7890',
                          controller: phoneController,
                          textStyle: textStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var newUser = UserModel(
                            name: nameController.text,
                            age: ageController.text,
                            phone: LocalDB.user!.phone,
                            image: "NA",
                            gender: selectedGender ?? "",
                            address: cityController.text,
                            email: emailController.text,
                          );
                          LocalDB.saveUser(newUser);

                          PreferenceController.saveStringData(
                              "Height", heightController.text);
                          PreferenceController.saveStringData(
                              "Weight", weightController.text);

                          FirestoreUserModel userDetails = FirestoreUserModel(
                            userName: nameController.text,
                            userPhone: phoneController.text,
                            userGender: selectedGender ?? "",
                            userAge: ageController.text,
                            userEmail: emailController.text,
                            userAddress: cityController.text,
                            userHeight: heightController.text,
                            userWeight: weightController.text,
                          );

                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(LocalDB.user!.phone)
                              .collection(
                                  FirebaseAuth.instance.currentUser!.uid)
                              .add(userDetails.toJson())
                              .then((value) => Navigator.pop(context));
                        }
                      },
                      child: const Text(
                        'save',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.fieldName,
    required this.fieldHint,
    required this.controller,
    required this.textStyle,
  });

  final String fieldName;
  final String fieldHint;
  final TextEditingController controller;

  final TextStyle textStyle;
  //  = const TextStyle(
  //   fontSize: 14.0,
  //   fontWeight: FontWeight.w400,
  // ); // height: 2.0, color: Colors.black),

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(fieldName, style: textStyle),
          const SizedBox(height: 6),
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter $fieldName';
              }
              if (fieldName == "Weight(kg)" &&
                  (int.parse(value) < 1 || int.parse(value) > 200)) {
                return 'Please enter valid $fieldName';
              }
              if (fieldName == "Height(cm)" &&
                  (int.parse(value) < 1 || int.parse(value) > 200)) {
                return 'Please enter valid $fieldName';
              }
              return null;
            },
            controller: controller,
            style: textStyle,
            readOnly: fieldName != 'Phone Number' ? false : true,
            enabled: fieldName == 'Phone Number' ? false : true,
            keyboardType: (fieldName == 'Height(cm)' ||
                    fieldName == "Weight(kg)" ||
                    fieldName == "Age")
                ? const TextInputType.numberWithOptions(
                    decimal: true, signed: true)
                : TextInputType.text,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: fieldName,
              isDense: true,
            ),
            inputFormatters: (fieldName == 'Height(cm)' ||
                    fieldName == "Weight(kg)")
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    LengthLimitingTextInputFormatter(3), // Limit to 3 digits
                  ]
                : (fieldName == 'Name')
                    ? <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z ]+')),
                      ]
                    : (fieldName == 'Age')
                        ? <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ]
                        : null,
          ),
        ],
      ),
    );
  }
}

// BorderSide({
//   Color color = const Color(0xFF000000), 
//   double width = 1.0, BorderStyle style = BorderStyle.solid, 
//   double strokeAlign = strokeAlignInside})
