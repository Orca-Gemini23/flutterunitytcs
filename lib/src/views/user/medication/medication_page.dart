import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/user_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';

class MedicationPage extends StatelessWidget {
  const MedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userController.prescriptionNameController.text,
          style: const TextStyle(
            color: AppColor.greenDarkColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.blackColor,
          ),
          onPressed: (() {
            Go.back(context: context);
          }),
        ),
        centerTitle: false,
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
      ),
      body: ListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addMedicine(context, userController),
        backgroundColor: AppColor.greenDarkColor,
        child: const Icon(Icons.add, color: AppColor.whiteColor),
      ),
    );
  }

  Future<void> addMedicine(
      BuildContext context, UserController userController) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0), topLeft: Radius.circular(16.0)),
      ),
      builder: (context) => Container(
        // width: 150,

        // padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 10),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(16.0),
        //   color: AppColor.whiteColor,
        // ),
        child: Form(
          key: userController.medicineFormKey,
          child: Stack(
            children: [
              Positioned(
                top: 60,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    const SizedBox(
                      height: 16,
                    ),
                    ...List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: userController.medNameController,
                          cursorColor: AppColor.greenDarkColor,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              return null;
                            } else {
                              return 'Field cannot be empty!';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                            focusColor: AppColor.greenDarkColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Align(
                    //   child: TextFormField(
                    //     controller: userController.medDescController,
                    //     cursorColor: AppColor.greenDarkColor,
                    //     validator: (value) {
                    //       if (value != null && value.isNotEmpty) {
                    //         return null;
                    //       } else {
                    //         return 'Field cannot be empty!';
                    //       }
                    //     },
                    //     decoration: InputDecoration(
                    //       labelText: 'Description',
                    //       hintText: 'Prescribed by?',
                    //       focusColor: AppColor.greenDarkColor,
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(12.0),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(12.0),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(12.0),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              // prescriptionNameController.clear();
                              // prescriptionDoctorController.clear();
                              Go.back(context: context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.whiteColor,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: AppColor.greenDarkColor),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // if (_prescriptionFormKey.currentState!.validate()) {
                              //   Go.to(
                              //       context: context,
                              //       push: const MedicationPage());
                              // } else {
                              //   log('Field EMPTY!');
                              // }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.greenDarkColor,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              'OK',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: const BoxDecoration(
                  color: AppColor.greenDarkColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0),
                  ),
                ),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Medicine Details",
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.whiteColor,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'ADD',
                        style: TextStyle(
                          color: AppColor.greenDarkColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
