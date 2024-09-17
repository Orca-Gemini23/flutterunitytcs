import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:table_calendar/table_calendar.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/auth/phone_auth.dart';
import 'package:walk/src/views/calendar/calendar_view.dart';
// import 'package:walk/src/views/physiotherapist/landing_page.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';

String country = "India";
Map<DateTime, List<int>> _kEventSource = {};

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
  final TextEditingController phoneController =
      TextEditingController(text: LocalDB.user!.phone);
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  File? _image;
  bool emailValid = false;
  List<String> list = <String>['India', 'England'];
  String selectedCountryCode = '+91';
  Map<String, String> selecteCountryCode = {'India': '+91', 'England': '+44'};
  //  { '+91':'India', '+44':'England'};

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
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Revised Account Page')
        .then(
          (value) => debugPrint("Analytics stated"),
        );
    super.initState();
    if (LocalDB.user!.image != "NA") {
      _image = File(LocalDB.user!.image);
    }
    _loadCountry();
    loadEvents();
  }

  void _loadCountry() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      country = (prefs.getString('country') ?? 'India');
    });
  }

  void _storeCountry(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('country', value);
  }

  Future<void> saveEvents(Map<DateTime, List<int>> events) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedEvents = events.map((key, value) {
      return MapEntry(key.toString(), value);
    });
    await prefs.setString('kEventSource', jsonEncode(encodedEvents));
  }

  Future<Map<DateTime, List<int>>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('kEventSource');
    if (savedData != null) {
      final decodedData = jsonDecode(savedData);
      final formattedData = <DateTime, List<int>>{};
      decodedData.forEach((key, value) {
        formattedData[DateTime.parse(key)] = List<int>.from(value);
      });
      return formattedData;
    }
    return {}; // Return an empty map if no data is found
  }

  void _showGenderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  setState(() {
                    genderController.text = 'Male';
                  });

                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  setState(() {
                    genderController.text = 'Female';
                  });

                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Other'),
                onTap: () {
                  setState(() {
                    genderController.text = 'Other';
                  });

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        title: const Text(
          'My Accounts',
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: 19,
          ),
        ),
        // actions: [
        // IconButton(
        //   onPressed: () async {
        //     final loadedEvents = await loadEvents();
        //     if (loadedEvents.isNotEmpty) {
        //       _kEventSource.addAll(loadedEvents);
        //     }
        //     final now = DateTime.now();
        //     final kToday = DateTime(now.year, now.month, now.day);
        //     // final kTomorrow =
        //     //     DateTime(kToday.year, kToday.month, kToday.day + 1);
        //     final DateTime kFirstDay =
        //         DateTime(kToday.year - 100, kToday.month, kToday.day);
        //     final DateTime kLastDay =
        //         DateTime(kToday.year, kToday.month + 1, 0);

        //     int getHashCode(DateTime key) {
        //       return key.day * 1000000 + key.month * 10000 + key.year;
        //     }

        //     if (!_kEventSource.containsKey(kToday)) {
        //       _kEventSource[kToday] = [1, 2];
        //       await saveEvents(_kEventSource);
        //     }

        //     final kEvents = LinkedHashMap<DateTime, List<int>>(
        //       equals: isSameDay,
        //       hashCode: getHashCode,
        //     )..addAll(_kEventSource);

        //     // FirebaseCrashlytics.instance.crash();
        //     // ignore: use_build_context_synchronously
        //     Go.to(
        //       context: context,
        //       push: CalendarEvents(
        //         kEvents: kEvents,
        //         kFirstDay: kFirstDay,
        //         kLastDay: kLastDay,
        //       ),
        //     );
        //   },
        //   icon: const Icon(
        //     Icons.calendar_month_outlined,
        //   ),
        // ),
        // ],
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
                            Expanded(
                              child: TextFormField(
                                controller: ageController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your age';
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(
                                      2), // Limit input to 3 digits only
                                ],
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  signed: true,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Age',
                                  focusColor: AppColor.greenDarkColor,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showGenderDialog(context),
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: genderController,
                                    decoration: const InputDecoration(
                                      labelText: 'Gender',
                                      focusColor: AppColor.greenDarkColor,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: cityController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your city';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          nameRegex),
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: 'City',
                                      focusColor: AppColor.greenDarkColor,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  flex: 1,
                                  child: DropdownButtonFormField<String>(
                                    value: country,
                                    onChanged: (String? newValue) async {
                                      setState(() {
                                        country = newValue!;
                                        print(country);
                                      });
                                    },
                                    items: list.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'Enter phone number',
                            labelText: 'Phone Number',
                          ),
                        ),
                        // Container(
                        //   height: 60,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: Text(phoneNo),
                        // ),
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
                          keyboardType: TextInputType.emailAddress,
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
                          resetAfterDuration: true,
                          resetDuration:
                              const Duration(seconds: 2, milliseconds: 500),
                          animateOnTap: true,
                          color: AppColor.greenDarkColor,
                          width: double.maxFinite,
                          curve: Curves.easeIn,
                          successColor: AppColor.greenDarkColor,
                          height: 60,
                          loaderSize: 25,
                          controller: _buttonController,
                          onPressed: () {
                            print(
                                "$selectedCountryCode${phoneController.text}");
                            emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(emailController.text);
                            if (_formKey.currentState!.validate() &&
                                emailValid) {
                              var newUser = UserModel(
                                name: nameController.text,
                                age: ageController.text,
                                phone: LocalDB.user!.phone,
                                image: _image?.path ?? "NA",
                                gender: genderController.text,
                                address: cityController.text,
                                email: emailController.text,
                              );

                              LocalDB.saveUser(newUser);
                              _storeCountry(country);

                              Timer(const Duration(seconds: 2), () {
                                _buttonController.success();
                              });
                              Timer(const Duration(seconds: 4), () {
                                Navigator.pop(context);
                              });
                              // Go.to(
                              //     context: context, push: const LandingPage());
                            } else {
                              Fluttertoast.showToast(
                                msg: "Please enter details correctly",
                              );
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
