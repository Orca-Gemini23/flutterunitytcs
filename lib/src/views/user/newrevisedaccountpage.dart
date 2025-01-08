import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/firestoreusermodel.dart';
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';
import 'package:walk/walk_app.dart';

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
  final TextEditingController phoneController = TextEditingController(
      text: LocalDB.user!.phone == ""
          ? FirebaseAuth.instance.currentUser!.phoneNumber
          : LocalDB.user!.phone);
  TextEditingController heightController =
      TextEditingController(text: DetailsPage.height);
  TextEditingController weightController =
      TextEditingController(text: DetailsPage.weight);
  final _formKey = GlobalKey<FormState>();

  bool changeInPage = false;

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

  static final List<String> genders = [
    'Male',
    'Female',
    'Other',
    'prefer not to say'
  ];
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
  bool validate = false;

  String? nameErrorMessage;
  void validateNameInput(String value) {
    setState(() {
      if (value.isEmpty) {
        nameErrorMessage = 'Please enter Name';
      } else if (value.length > 50) {
        // nameErrorMessage = 'Name is too long';
        nameController.text = nameController.text.substring(0, 50);
      } else {
        nameErrorMessage = null;
      }
    });
  }

  String? ageErrorMessage;
  void validateAgeInput(String value) {
    setState(() {
      if (value.isEmpty) {
        ageErrorMessage = 'Please enter Age';
      } else if (int.parse(value) > 130) {
        // ageErrorMessage = 'invalid age';
        ageController.text = ageController.text.substring(0, 2);
      } else {
        ageErrorMessage = null;
      }
    });
  }

  String? addressErrorMessage;
  void validateAddressInput(String value) {
    setState(() {
      if (value.isEmpty) {
        addressErrorMessage = 'Please enter Address';
      } else if (!RegExp(r"[a-zA-Z]").hasMatch(value)) {
        addressErrorMessage = "please enter correct address";
      } else if (value.length > 90) {
        // nameErrorMessage = 'Name is too long';
        cityController.text = cityController.text.substring(0, 90);
      } else {
        addressErrorMessage = null;
      }
    });
  }

  String? heightErrorMessage;
  void validateHeightInput(String value) {
    setState(() {
      if (value.isEmpty) {
        heightErrorMessage = 'Please enter height';
      } else if (int.parse(value) > 240) {
        // heightErrorMessage = 'invalid height';
        heightController.text = heightController.text.substring(0, 2);
      } else {
        heightErrorMessage = null;
      }
    });
  }

  String? weightErrorMessage;
  void validateWeightInput(String value) {
    setState(() {
      if (value.isEmpty) {
        weightErrorMessage = 'Please enter weight';
      } else if (int.parse(value) > 200) {
        // weightErrorMessage = 'invalid weight';
        weightController.text = weightController.text.substring(0, 2);
      } else {
        weightErrorMessage = null;
      }
    });
  }

  String? emailErrorMessage;
  void validateEmailInput(String value) {
    setState(() {
      if (value.isEmpty) {
        emailErrorMessage = 'Please enter email';
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~][^ @]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
          .hasMatch(value)) {
        emailErrorMessage = 'Please enter valid E-mail';
      } else {
        emailErrorMessage = null;
      }
      if (value.length > 255) {
        // nameErrorMessage = 'Name is too long';
        emailController.text = emailController.text.substring(0, 254);
      }
    });
  }

  String? phoneErrorMessage;
  void validatePhoneInput(String value) {
    setState(() {
      if (value.isEmpty) {
        phoneErrorMessage = 'Please enter phone number';
      } else if (!RegExp(
              r"^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$")
          .hasMatch(value)) {
        phoneErrorMessage = 'Please enter valid phone number';
      } else {
        phoneErrorMessage = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (LocalDB.user!.image != "NA") {
      // _image = File(LocalDB.user!.image);
    }
    if (!kDebugMode) {
      FirebaseAnalytics.instance
          .logScreenView(screenName: 'Revised Account Page')
          .then((value) => debugPrint("Analytics stated in Revised Account"));
    }
  }

  void _onWillPop() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                LocalDB.saveUser(LocalDB.defaultUser);
                PreferenceController.clearAllData();
                if (context.mounted) {
                  Go.pushAndRemoveUntil(
                    context: context,
                    pushReplacement: const WalkApp(),
                  );
                }
                // Navigator.of(context).pop();
              },
              child: const Text('Yes', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog without action
              },
              child: const Text('No',
                  style: TextStyle(
                      color: Color(0xFF005749), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !UserDetails.unavailable,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        _onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: AppColor.blackColor,
          ),
          leading: UserDetails.unavailable
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    _onWillPop();
                  },
                )
              : IconButton(
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
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
                  items: [
                    const PopupMenuItem<String>(
                      value: 'Delete Account',
                      child: Text('Delete Account'),
                    ),
                  ],
                ).then((value) async {
                  if (value != null) {
                    if (value == 'Delete Account') {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Account'),
                              content: const Text(
                                  'Are you sure you want to delete account?'),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseAuth.instance.currentUser
                                          ?.delete();
                                    } catch (e) {
                                      log("---->$e");
                                    }
                                    try {
                                      await FirebaseAuth.instance.signOut();
                                    } catch (e) {
                                      log("s---->$e");
                                    }
                                    LocalDB.saveUser(LocalDB.defaultUser);
                                    PreferenceController.clearAllData();
                                    Go.pushAndRemoveUntil(
                                      context: context,
                                      pushReplacement: const WalkApp(),
                                    );
                                  },
                                  child: const Text('Yes',
                                      style: TextStyle(color: Colors.black)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Closes the dialog without action
                                  },
                                  child: const Text('No',
                                      style: TextStyle(
                                          color: Color(0xFF005749),
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            );
                          });
                    }
                  }
                });
              },
            ),
          ],
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
                      // kDebugMode
                      //     ? Text(FirebaseAuth.instance.currentUser!.uid)
                      //     : SizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Name${UserDetails.unavailable ? "*" : ""}",
                                    style: textStyle),
                                const SizedBox(height: 6),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter Name';
                                    }
                                    if (value.length > 50) {
                                      return 'name is too long';
                                    }

                                    return null;
                                  },
                                  controller: nameController,
                                  style: textStyle,
                                  onChanged: (value) {
                                    setState(() {
                                      changeInPage = true;
                                    });
                                    nameController.text = nameController.text
                                        .replaceAll(RegExp(r'\s+$'), ' ');
                                    validateNameInput(value);
                                    if (validate) {
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: "Name",
                                    isDense: true,
                                    errorText: nameErrorMessage,
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[a-zA-Z ]+')),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     const Spacer(),
                                //     Text(
                                //       "${nameController.text.length}/50",
                                //       style: TextStyle(fontSize: 8),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Age${UserDetails.unavailable ? "*" : ""}",
                                      style: textStyle),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter Age';
                                      }
                                      return null;
                                    },
                                    controller: ageController,
                                    style: textStyle,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true, signed: true),
                                    onChanged: (value) {
                                      validateAgeInput(value);
                                      setState(() {
                                        changeInPage = true;
                                      });
                                      if (validate) {
                                        _formKey.currentState!.validate();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: "Age",
                                      isDense: true,
                                      errorText: ageErrorMessage,
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gender${UserDetails.unavailable ? "*" : ""}",
                                    style: textStyle,
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 14.5),
                                      ),
                                      hint: Text(
                                        'Gender',
                                        style: textStyle,
                                      ),
                                      value: selectedGender,
                                      validator: (value) => value == null
                                          ? 'Please select Gender'
                                          : null,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          changeInPage = true;
                                          selectedGender = newValue;
                                        });
                                        if (validate) {
                                          _formKey.currentState!.validate();
                                        }
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
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Address", style: textStyle),
                                const SizedBox(height: 6),
                                TextFormField(
                                  validator: (value) {
                                    if ((value == null ||
                                            value.trim().isEmpty) &&
                                        !UserDetails.unavailable) {
                                      return 'Please enter Address';
                                    }
                                    return null;
                                  },
                                  controller: cityController,
                                  style: textStyle,
                                  onChanged: (value) {
                                    validateAddressInput(value);
                                    setState(() {
                                      changeInPage = true;
                                    });
                                    if (validate) {
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: "Address",
                                    isDense: true,
                                    errorText: addressErrorMessage,
                                  ),
                                ),
                                // Row(
                                //   children: [
                                //     const Spacer(),
                                //     Text(
                                //       "${cityController.text.length}/90",
                                //       style: TextStyle(fontSize: 8),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Height(cm)", style: textStyle),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    validator: (value) {
                                      if (!UserDetails.unavailable) {
                                        if ((value == null ||
                                            value.trim().isEmpty)) {
                                          return 'Please enter Height';
                                        }

                                        if ((int.parse(value) < 1 ||
                                            int.parse(value) > 240)) {
                                          return 'Please enter valid Height';
                                        }
                                      }
                                      return null;
                                    },
                                    controller: heightController,
                                    style: textStyle,
                                    onChanged: (value) {
                                      validateHeightInput(value);
                                      setState(() {
                                        changeInPage = true;
                                      });
                                      if (validate) {
                                        _formKey.currentState!.validate();
                                      }
                                    },
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true, signed: true),
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: "Height",
                                      isDense: true,
                                      errorText: heightErrorMessage,
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Weight(kg)${UserDetails.unavailable ? "*" : ""}",
                                      style: textStyle),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter Weight';
                                      }
                                      if ((int.parse(value) < 1 ||
                                          int.parse(value) > 200)) {
                                        return 'Please enter valid Weight';
                                      }
                                      return null;
                                    },
                                    controller: weightController,
                                    style: textStyle,
                                    onChanged: (value) {
                                      validateWeightInput(value);
                                      setState(() {
                                        changeInPage = true;
                                      });
                                      if (validate) {
                                        _formKey.currentState!.validate();
                                      }
                                    },
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true, signed: true),
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: "Weight",
                                      isDense: true,
                                      errorText: weightErrorMessage,
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("E-mail", style: textStyle),
                                const SizedBox(height: 6),
                                TextFormField(
                                  validator: (value) {
                                    if ((value == null ||
                                            value.trim().isEmpty) &&
                                        !UserDetails.unavailable) {
                                      return 'Please enter E-mail';
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                  style: textStyle,
                                  onChanged: (value) {
                                    validateEmailInput(value);
                                    setState(() {
                                      changeInPage = true;
                                    });
                                    if (validate) {
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: "E-mail",
                                    isDense: true,
                                    errorText: emailErrorMessage,
                                  ),
                                ),
                                // Row(
                                //   children: [
                                //     const Spacer(),
                                //     Text(
                                //       "${emailController.text.length}/254",
                                //       style: TextStyle(fontSize: 8),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Phone Number", style: textStyle),
                                const SizedBox(height: 6),
                                TextFormField(
                                  validator: (value) {
                                    if ((value == null ||
                                            value.trim().isEmpty) &&
                                        !UserDetails.unavailable) {
                                      return 'Please enter Phone Number';
                                    }
                                    // else if (!RegExp(
                                    //         r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
                                    //     .hasMatch(value!)) {
                                    //   return 'Please enter valid phone number';
                                    // }

                                    return null;
                                  },
                                  controller: phoneController,
                                  style: textStyle,
                                  onChanged: (value) {
                                    validatePhoneInput(value);
                                    changeInPage = true;
                                  },
                                  readOnly: LocalDB.user!.phone.isEmpty
                                      ? false
                                      : true,
                                  enabled: LocalDB.user!.phone.isEmpty
                                      ? true
                                      : false,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true, signed: true),
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    isDense: true,
                                    hintText: "Phone Number",
                                    errorText: phoneErrorMessage,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // const Spacer(),
                      const SizedBox(height: 36),
                      ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: changeInPage
                            ? () async {
                                validate = true;
                                if (_formKey.currentState!.validate()) {
                                  emailErrorMessage = null;
                                  weightErrorMessage = null;
                                  heightErrorMessage = null;
                                  addressErrorMessage = null;
                                  ageErrorMessage = null;
                                  nameErrorMessage = null;
                                  var newUser = UserModel(
                                    name: nameController.text,
                                    age: ageController.text,
                                    phone: phoneController.text,
                                    image: "NA",
                                    gender: selectedGender ?? "",
                                    address: cityController.text,
                                    email: emailController.text,
                                  );
                                  LocalDB.saveUser(newUser);

                                  setState(() {
                                    DetailsPage.height = heightController.text;
                                    DetailsPage.weight = weightController.text;
                                  });

                                  PreferenceController.saveStringData(
                                      "Height", heightController.text);
                                  PreferenceController.saveStringData(
                                      "Weight", weightController.text);

                                  FirestoreUserModel userDetails =
                                      FirestoreUserModel(
                                    userName: nameController.text,
                                    userPhone: phoneController.text,
                                    userGender: selectedGender ?? "",
                                    userAge: ageController.text,
                                    userEmail: emailController.text,
                                    userAddress: cityController.text,
                                    userHeight: heightController.text,
                                    userWeight: weightController.text,
                                  );

                                  FirebaseFirestore.instance
                                      .collection("UserProfiles")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .set({
                                    "User Details": FieldValue.arrayUnion(
                                        [userDetails.toJson()]),
                                  }, SetOptions(merge: true)).then(
                                    (value) => {
                                      if (UserDetails.unavailable)
                                        {
                                          Go.pushAndRemoveUntil(
                                            context: context,
                                            pushReplacement:
                                                const RevisedHomePage(),
                                          ),
                                          setState(() {
                                            UserDetails.unavailable = false;
                                          }),
                                        }
                                    },
                                  );
                                }
                                setState(() {
                                  changeInPage = false;
                                });
                              }
                            : null,
                        child: Text(
                          UserDetails.unavailable ? 'continue' : 'save',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// retriving data
// FirebaseFirestore.instance
//     .collection("UserProfiles")
//     .doc(FirebaseAuth.instance.currentUser!.uid)
//     .get()
//     .then(
//   (DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     print(data["User Details"].last);
//   },
//   onError: (e) => print("Error getting document: $e"),
// );