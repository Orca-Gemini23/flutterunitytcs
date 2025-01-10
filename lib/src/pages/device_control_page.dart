// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/constants/bt_constants.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/pages/home_page.dart';
import 'package:walk/src/utils/firebase/firebase_db.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/additionalsettings/addsettings.dart';
import 'package:walk/src/views/dialogs/confirmationbox.dart';
import 'package:walk/src/widgets/devicecontrolpage/magnitudeslider.dart';
import 'package:walk/src/widgets/dialog.dart';

class DeviceControlPage extends StatefulWidget {
  const DeviceControlPage({super.key});

  @override
  State<DeviceControlPage> createState() => _DeviceControlPageState();
}

class _DeviceControlPageState extends State<DeviceControlPage>
    with WidgetsBindingObserver {
  late DeviceController deviceController;
  StreamSubscription<BluetoothConnectionState>? _deviceStateSubscription;
  bool isDialogup = true;
  late Future<bool> metricsFuture;
  RangeValues _currentRangeValues = const RangeValues(-30, 30);
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  final FocusNode _minFocusNode = FocusNode();
  final FocusNode _maxFocusNode = FocusNode();
  bool? previousValue;
  bool magChanger = false;

  // Right Band Angle
  RangeValues _currentRangeValuesRight = const RangeValues(-30, 30);
  final TextEditingController _minControllerRight = TextEditingController();
  final TextEditingController _maxControllerRight = TextEditingController();
  final FocusNode _minFocusNodeRight = FocusNode();
  final FocusNode _maxFocusNodeRight = FocusNode();
  bool isInclusive = false;
  bool isInclusiveRight = false;

  Future<bool> getDeviceMetrics() async {
    try {
      await deviceController.getBatteryPercentageValues();

      await deviceController.getFrequencyValues();

      await deviceController.getMagnitudeValues();

      await deviceController.getClientConnectionStatus();

      return true;
    } catch (e) {
      // print(e);
      throw "Something went wrong , please try again ";
    }
  }

  @override
  void initState() {
    FirebaseAnalytics.instance
        .logScreenView(screenName: 'Device Control Page')
        .then(
          (value) => debugPrint("Analytics stated"),
        );
    super.initState();
    deviceController = Provider.of<DeviceController>(context, listen: false);
    metricsFuture = getDeviceMetrics();
    _minController.text = _currentRangeValues.start.toStringAsFixed(0);
    _maxController.text = _currentRangeValues.end.toStringAsFixed(0);

    // Add listeners for when the user leaves the input fields
    _minFocusNode.addListener(() {
      if (!_minFocusNode.hasFocus) {
        _validateAndUpdateMin();
      }
    });

    _maxFocusNode.addListener(() {
      if (!_maxFocusNode.hasFocus) {
        _validateAndUpdateMax();
      }
    });
    // Right
    _minControllerRight.text =
        _currentRangeValuesRight.start.toStringAsFixed(0);
    _maxControllerRight.text = _currentRangeValuesRight.end.toStringAsFixed(0);

    // Add listeners for when the user leaves the input fields
    _minFocusNodeRight.addListener(() {
      if (!_minFocusNodeRight.hasFocus) {
        _validateAndUpdateMinRight();
      }
    });

    _maxFocusNodeRight.addListener(() {
      if (!_maxFocusNodeRight.hasFocus) {
        _validateAndUpdateMaxRight();
      }
    });
  }

  @override
  void dispose() {
    _deviceStateSubscription?.cancel();
    super.dispose();
    _minController.dispose();
    _maxController.dispose();
    _minFocusNode.dispose();
    _maxFocusNode.dispose();
    _minControllerRight.dispose();
    _maxControllerRight.dispose();
    _minFocusNodeRight.dispose();
    _maxFocusNodeRight.dispose();
    scrollController.dispose();
  }

  void _validateAndUpdateMin() {
    setState(() {
      final min =
          double.tryParse(_minController.text) ?? _currentRangeValues.start;
      final clampedMin = min.clamp(
          -90.0,
          _currentRangeValues
              .end); // Clamp min to -90 and max can't be less than end
      _currentRangeValues = RangeValues(clampedMin, _currentRangeValues.end);
      _minController.text = clampedMin
          .toStringAsFixed(0); // Update input field with the clamped value
    });
  }

  // Method to validate and update the max value
  void _validateAndUpdateMax() {
    setState(() {
      final max =
          double.tryParse(_maxController.text) ?? _currentRangeValues.end;
      final clampedMax = max.clamp(_currentRangeValues.start,
          90.0); // Clamp max to 90 and can't be less than start
      _currentRangeValues = RangeValues(_currentRangeValues.start, clampedMax);
      _maxController.text = clampedMax
          .toStringAsFixed(0); // Update input field with the clamped value
    });
  }

  void _validateAndUpdateMinRight() {
    setState(() {
      final min = double.tryParse(_minControllerRight.text) ??
          _currentRangeValuesRight.start;
      final clampedMin = min.clamp(
          -90.0,
          _currentRangeValuesRight
              .end); // Clamp min to -90 and max can't be less than end
      _currentRangeValuesRight =
          RangeValues(clampedMin, _currentRangeValuesRight.end);
      _minControllerRight.text = clampedMin
          .toStringAsFixed(0); // Update input field with the clamped value
    });
  }

  // Method to validate and update the max value
  void _validateAndUpdateMaxRight() {
    setState(() {
      final max = double.tryParse(_maxControllerRight.text) ??
          _currentRangeValuesRight.end;
      final clampedMax = max.clamp(_currentRangeValuesRight.start,
          90.0); // Clamp max to 90 and can't be less than start
      _currentRangeValuesRight =
          RangeValues(_currentRangeValuesRight.start, clampedMax);
      _maxControllerRight.text = clampedMax
          .toStringAsFixed(0); // Update input field with the clamped value
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
    return false;
  }

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          await _onWillPop();
        },
        child: Scaffold(
          extendBody: false,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: AppColor.blackColor,
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: DeviceSize.isTablet ? 36 : 24,
              ),
              onPressed: (() {
                Navigator.pop(context);
              }),
            ),
            title: Text(
              "Device Control",
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: DeviceSize.isTablet ? 36 : 16,
              ),
            ),
          ),
          body: RawScrollbar(
            controller: scrollController,
            thumbVisibility: AdvancedMode.modevisiable,
            thickness: 8,
            radius: const Radius.circular(10),
            minThumbLength: 10,
            thumbColor: AppColor.lightgreen,
            child: StreamBuilder<BluetoothConnectionState>(
                stream: deviceController.connectedDevice?.connectionState ??
                    const Stream.empty(),
                builder: (context, connectionSnapshot) {
                  if (connectionSnapshot.data ==
                      BluetoothConnectionState.disconnected) {
                    deviceController.isScanning = false;
                    deviceController.isConnecting = false;
                    if (isDialogup) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (timeStamp) {
                          setState(() {
                            isDialogup = false;
                          });
                          deviceController.clearConnectedDevice();

                          CustomDialogs.showBleDisconnectedDialog(context);
                        },
                      );
                    }
                  }

                  return FutureBuilder<bool>(
                    builder: (context, deviceMetricSnapshot) {
                      switch (deviceMetricSnapshot.connectionState) {
                        case ConnectionState.waiting:
                          {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.greenDarkColor,
                              ),
                            );
                          }
                        case ConnectionState.done:
                        default:
                          if (deviceMetricSnapshot.hasError) {
                            return const Center(
                              child: Text(
                                  "Some error occurred getting device details. Try again."),
                            );
                          } else if (deviceMetricSnapshot.hasData) {
                            return Consumer<DeviceController>(
                              builder: (context, deviceController, widget) {
                                deviceController.isScanning = false;
                                TextEditingController frequencyTextController =
                                    deviceController.frequencyValue < 0
                                        ? TextEditingController(text: " ")
                                        : TextEditingController(
                                            text: (deviceController
                                                        .frequencyValue *
                                                    60)
                                                .toStringAsFixed(0));
                                // deviceController.getClientConnectionStream();
                                // deviceController
                                //     .getClientConnectionStatus()
                                //     .asStream()
                                //     .listen((onData) {
                                //   print(onData);
                                // });
                                return Container(
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  padding: const EdgeInsets.only(
                                    bottom: 15,
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: DeviceSize.isTablet
                                              ? 200.h
                                              : 180.h,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.lightbluegrey,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              if (DeviceSize.isTablet)
                                                const SizedBox(width: 20),
                                              Image(
                                                height: DeviceSize.isTablet
                                                    ? 189.h
                                                    : 119.h,
                                                width: 119.w,
                                                alignment: Alignment.centerLeft,
                                                fit: BoxFit.fitHeight,
                                                image: const AssetImage(
                                                  "assets/images/battery.png",
                                                ),
                                              ),
                                              SizedBox(
                                                width: DeviceSize.isTablet
                                                    ? 30
                                                    : 10,
                                              ),
                                              GestureDetector(
                                                onVerticalDragDown: (_) async {
                                                  await deviceController
                                                      .refreshBatteryValues();
                                                  Analytics.addClicks(
                                                      "BatteryRefreshDrag",
                                                      DateTime.timestamp());
                                                },
                                                child: Container(
                                                  ////Left Battery Container
                                                  width: 90.w,
                                                  height: DeviceSize.isTablet
                                                      ? 185.h
                                                      : 135.h,

                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: AppColor.whiteColor,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          offset: Offset(4, 4),
                                                          color:
                                                              AppColor.black12,
                                                          blurRadius: 3,
                                                          spreadRadius: 1),
                                                      BoxShadow(
                                                          offset: Offset(-4, 0),
                                                          color:
                                                              AppColor.black12,
                                                          blurRadius: 5,
                                                          spreadRadius: 1)
                                                    ],
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: double.maxFinite,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 5),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: AppColor
                                                              .lightgreen,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: Text(
                                                          "Left",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Visibility(
                                                        replacement:
                                                            CircularPercentIndicator(
                                                          radius: 20.w,
                                                          backgroundColor:
                                                              AppColor
                                                                  .lightgreen,
                                                        ),
                                                        child:
                                                            CircularPercentIndicator(
                                                          lineWidth: DeviceSize
                                                                  .isTablet
                                                              ? 15
                                                              : 7,
                                                          percent:
                                                              deviceController
                                                                      .battS /
                                                                  100,
                                                          radius: 20.w,
                                                          center: deviceController
                                                                      .battS <
                                                                  30
                                                              ? Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red,
                                                                  size: DeviceSize
                                                                          .isTablet
                                                                      ? 50
                                                                      : null,
                                                                )
                                                              : null,
                                                          progressColor:
                                                              deviceController
                                                                          .battS <
                                                                      30
                                                                  ? Colors.red
                                                                  : AppColor
                                                                      .greenDarkColor,
                                                          circularStrokeCap:
                                                              CircularStrokeCap
                                                                  .round,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "${deviceController.battS}%",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                          fontSize: 16.h,
                                                          letterSpacing: 1,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: DeviceSize.isTablet
                                                    ? 30
                                                    : 10,
                                              ),
                                              GestureDetector(
                                                onVerticalDragDown:
                                                    (details) async {
                                                  await deviceController
                                                      .refreshBatteryValues();
                                                },
                                                child: Container(
                                                  ////Right Battery Container
                                                  width: 90.w,
                                                  height: DeviceSize.isTablet
                                                      ? 185.h
                                                      : 135.h,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          AppColor.whiteColor,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          offset: Offset(4, 4),
                                                          color:
                                                              AppColor.black12,
                                                          blurRadius: 3,
                                                          spreadRadius: 1,
                                                        ),
                                                        BoxShadow(
                                                          offset: Offset(-4, 0),
                                                          color:
                                                              AppColor.black12,
                                                          blurRadius: 5,
                                                          spreadRadius: 1,
                                                        )
                                                      ]),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: double.maxFinite,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 5),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: AppColor
                                                              .lightgreen,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: Text(
                                                          "Right",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      CircularPercentIndicator(
                                                        lineWidth:
                                                            DeviceSize.isTablet
                                                                ? 15
                                                                : 7,
                                                        percent: deviceController
                                                                    .battC <
                                                                0
                                                            ? deviceController
                                                                    .battC *
                                                                -1
                                                            : deviceController
                                                                    .battC /
                                                                100,
                                                        radius: 20.w,
                                                        center: (!deviceController
                                                                    .bandC ||
                                                                deviceController
                                                                        .battC <
                                                                    0 ||
                                                                deviceController
                                                                        .magCValue <
                                                                    0 ||
                                                                deviceController
                                                                        .frequencyValue <
                                                                    0)
                                                            ? Icon(
                                                                Icons.error,
                                                                color:
                                                                    Colors.grey,
                                                                size: DeviceSize
                                                                        .isTablet
                                                                    ? 50
                                                                    : null,
                                                              )
                                                            : deviceController
                                                                        .battC <
                                                                    30
                                                                ? Icon(
                                                                    Icons.error,
                                                                    color: Colors
                                                                        .red,
                                                                    size: DeviceSize
                                                                            .isTablet
                                                                        ? 50
                                                                        : null,
                                                                  )
                                                                : null,
                                                        progressColor: (!deviceController
                                                                    .bandC ||
                                                                deviceController
                                                                        .battC <
                                                                    0 ||
                                                                deviceController
                                                                        .magCValue <
                                                                    0 ||
                                                                deviceController
                                                                        .frequencyValue <
                                                                    0)
                                                            ? Colors.grey
                                                            : deviceController
                                                                        .battC <
                                                                    30
                                                                ? Colors.red
                                                                : AppColor
                                                                    .greenDarkColor,
                                                        circularStrokeCap:
                                                            CircularStrokeCap
                                                                .round,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        (!deviceController
                                                                    .bandC ||
                                                                deviceController
                                                                        .battC <
                                                                    0 ||
                                                                deviceController
                                                                        .magCValue <
                                                                    0 ||
                                                                deviceController
                                                                        .frequencyValue <
                                                                    0)
                                                            ? "??"
                                                            : "${deviceController.battC}%",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                          fontSize: 16.h,
                                                          letterSpacing: 1,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const AdditionalSettings(),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: AppColor.lightgreen,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: AppColor.greyLight,
                                                  offset: Offset(0, 2),
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  blurStyle: BlurStyle.normal,
                                                )
                                              ]),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          width: double.maxFinite,
                                          height: DeviceSize.isTablet
                                              ? 147.h
                                              : 107.h,
                                          child: AbsorbPointer(
                                            absorbing: (!deviceController
                                                    .bandC ||
                                                deviceController.battC < 0 ||
                                                deviceController.magCValue <
                                                    0 ||
                                                deviceController
                                                        .frequencyValue <
                                                    0),
                                            child: Padding(
                                              padding: DeviceSize.isTablet
                                                  ? const EdgeInsets.all(16.0)
                                                  : const EdgeInsets.all(0),
                                              child: Stack(
                                                textDirection:
                                                    TextDirection.ltr,
                                                children: [
                                                  Positioned(
                                                    top: 0.h,
                                                    child: Text(
                                                      AppString.frequency,
                                                      style: TextStyle(
                                                        color:
                                                            AppColor.blackColor,
                                                        fontSize:
                                                            DeviceSize.isTablet
                                                                ? 20.h
                                                                : 16.sp,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    right: 0,
                                                    top: DeviceSize.isTablet
                                                        ? 30.h
                                                        : 20.h,
                                                    bottom: 0,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: DeviceSize
                                                                  .isTablet
                                                              ? 5
                                                              : 3,
                                                          child: SliderTheme(
                                                            data:
                                                                SliderThemeData(
                                                              thumbShape: RoundSliderThumbShape(
                                                                  enabledThumbRadius:
                                                                      DeviceSize
                                                                              .isTablet
                                                                          ? 18
                                                                          : 10),
                                                              trackHeight:
                                                                  DeviceSize
                                                                          .isTablet
                                                                      ? 16
                                                                      : 8,
                                                              activeTrackColor: (!deviceController
                                                                          .bandC ||
                                                                      deviceController
                                                                              .battC <
                                                                          0 ||
                                                                      deviceController
                                                                              .magCValue <
                                                                          0 ||
                                                                      deviceController
                                                                              .frequencyValue <
                                                                          0)
                                                                  ? Colors.grey
                                                                  : AppColor
                                                                      .greenDarkColor,
                                                            ),
                                                            child: Slider(
                                                              value: deviceController
                                                                          .frequencyValue ==
                                                                      -1
                                                                  ? 0.3
                                                                  : deviceController
                                                                      .frequencyValue,
                                                              min: 0.3,
                                                              max: 2,
                                                              label: deviceController
                                                                  .frequencyValue
                                                                  .toString(),
                                                              thumbColor: (!deviceController
                                                                          .bandC ||
                                                                      deviceController
                                                                              .battC <
                                                                          0 ||
                                                                      deviceController
                                                                              .magCValue <
                                                                          0 ||
                                                                      deviceController
                                                                              .frequencyValue <
                                                                          0)
                                                                  ? Colors.grey
                                                                  : AppColor
                                                                      .greenDarkColor,
                                                              onChanged:
                                                                  (value) {
                                                                if (deviceController
                                                                    .bandC) {
                                                                  HapticFeedback
                                                                      .lightImpact();
                                                                  deviceController
                                                                      .setfreqValue(
                                                                          value);
                                                                } else {
                                                                  null;
                                                                }
                                                                frequencyTextController
                                                                        .text =
                                                                    (value * 60)
                                                                        .toStringAsFixed(
                                                                            0);
                                                              },
                                                              onChangeEnd:
                                                                  (value) async {
                                                                if (deviceController
                                                                    .bandC) {
                                                                  Analytics.addClicks(
                                                                      "FrequencySlider-${(value * 60).toStringAsFixed(0)}",
                                                                      DateTime
                                                                          .timestamp());
                                                                  String approxFrequency = deviceController
                                                                              .frequencyValue
                                                                              .toString()
                                                                              .length >
                                                                          3
                                                                      ? deviceController
                                                                          .frequencyValue
                                                                          .toString()
                                                                          .substring(
                                                                              0,
                                                                              4)
                                                                      : deviceController
                                                                          .frequencyValue
                                                                          .toString();

                                                                  String
                                                                      command =
                                                                      "$FREQ c $approxFrequency;";
                                                                  await deviceController
                                                                      .sendToDevice(
                                                                          command,
                                                                          WRITECHARACTERISTICS);
                                                                  frequencyTextController
                                                                      .text = (value *
                                                                          60)
                                                                      .toStringAsFixed(
                                                                          0);
                                                                } else {
                                                                  null;
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        if (DeviceSize.isTablet)
                                                          const SizedBox(
                                                              width: 30),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            height: DeviceSize
                                                                    .isTablet
                                                                ? 80
                                                                : 40,
                                                            // width: 1,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: TextField(
                                                                textAlign: TextAlign
                                                                    .center,
                                                                textAlignVertical:
                                                                    TextAlignVertical
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        DeviceSize
                                                                                .isTablet
                                                                            ? 12
                                                                                .sp
                                                                            : 15),
                                                                controller:
                                                                    frequencyTextController,
                                                                decoration: InputDecoration(
                                                                    border:
                                                                        const OutlineInputBorder(),
                                                                    labelText:
                                                                        'steps/min',
                                                                    labelStyle: TextStyle(
                                                                        fontSize: DeviceSize.isTablet
                                                                            ? 12
                                                                                .sp
                                                                            : 14)),
                                                                inputFormatters: <TextInputFormatter>[
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly,
                                                                  LengthLimitingTextInputFormatter(
                                                                      3),
                                                                ],
                                                                keyboardType:
                                                                    const TextInputType
                                                                        .numberWithOptions(
                                                                        signed:
                                                                            true,
                                                                        decimal:
                                                                            true),
                                                                onSubmitted:
                                                                    (value) async {
                                                                  if (double.parse(
                                                                          value) >
                                                                      120) {
                                                                    value =
                                                                        "120";
                                                                  }
                                                                  if (double.parse(
                                                                          value) <
                                                                      18) {
                                                                    value =
                                                                        "18";
                                                                  }
                                                                  Analytics.addClicks(
                                                                      "FrequencyTextField-${(value)}",
                                                                      DateTime
                                                                          .timestamp());
                                                                  if (deviceController
                                                                      .bandC) {
                                                                    setState(
                                                                        () {
                                                                      try {
                                                                        deviceController.setfreqValue(double.parse(value) /
                                                                            60);
                                                                      } catch (e) {
                                                                        debugPrint(
                                                                            e.toString());
                                                                      }
                                                                    });
                                                                    String approxFrequency = deviceController.frequencyValue.toString().length >
                                                                            3
                                                                        ? deviceController
                                                                            .frequencyValue
                                                                            .toString()
                                                                            .substring(0,
                                                                                4)
                                                                        : deviceController
                                                                            .frequencyValue
                                                                            .toString();

                                                                    String
                                                                        command =
                                                                        "$FREQ c $approxFrequency;";
                                                                    await deviceController.sendToDevice(
                                                                        command,
                                                                        WRITECHARACTERISTICS);
                                                                  } else {
                                                                    null;
                                                                  }
                                                                }),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: AppColor.lightgreen,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: AppColor.greyLight,
                                                  offset: Offset(0, 2),
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  blurStyle: BlurStyle.normal,
                                                )
                                              ]),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          width: double.maxFinite,
                                          height: DeviceSize.isTablet
                                              ? 170.h
                                              : 140.h,
                                          child: Padding(
                                            padding: DeviceSize.isTablet
                                                ? const EdgeInsets.all(8.0)
                                                : const EdgeInsets.all(0),
                                            child: Stack(
                                              textDirection: TextDirection.ltr,
                                              children: [
                                                Positioned(
                                                  child: Text(
                                                    AppString.magnitude,
                                                    style: TextStyle(
                                                      color:
                                                          AppColor.blackColor,
                                                      fontSize:
                                                          DeviceSize.isTablet
                                                              ? 20.h
                                                              : 16.sp,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    top: DeviceSize.isTablet
                                                        ? 80
                                                        : 40,
                                                    left: 0,
                                                    right: 0,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Left",
                                                                style: TextStyle(
                                                                    fontSize: DeviceSize
                                                                            .isTablet
                                                                        ? 12.sp
                                                                        : 14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              if (DeviceSize
                                                                  .isTablet)
                                                                const SizedBox(
                                                                    height: 20),
                                                              magSlider(false,
                                                                  deviceController),
                                                            ],
                                                          ),
                                                        ),
                                                        // const Spacer(),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Right",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: DeviceSize
                                                                          .isTablet
                                                                      ? 12.sp
                                                                      : 14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              if (DeviceSize
                                                                  .isTablet)
                                                                const SizedBox(
                                                                    height: 20),
                                                              AbsorbPointer(
                                                                absorbing: (!deviceController
                                                                        .bandC ||
                                                                    deviceController
                                                                            .battC <
                                                                        0 ||
                                                                    deviceController
                                                                            .magCValue <
                                                                        0 ||
                                                                    deviceController
                                                                            .frequencyValue <
                                                                        0),
                                                                child: magSlider(
                                                                    true,
                                                                    deviceController),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Visibility(
                                          visible: AdvancedMode.modevisiable,
                                          child: Column(children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppColor.lightgreen,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: AppColor.greyLight,
                                                      offset: Offset(0, 2),
                                                      blurRadius: 4,
                                                      spreadRadius: 0,
                                                      blurStyle:
                                                          BlurStyle.normal,
                                                    )
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Range Slider
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        'Angle Mode',
                                                        style: TextStyle(
                                                          color: AppColor
                                                              .blackColor,
                                                          fontSize: DeviceSize
                                                                  .isTablet
                                                              ? 20.h
                                                              : 16.sp,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Text(
                                                                'Left Band Range',
                                                                style: TextStyle(
                                                                    color: AppColor
                                                                        .greenDarkColor,
                                                                    fontSize: DeviceSize
                                                                            .isTablet
                                                                        ? 18.h
                                                                        : 14.sp,
                                                                    letterSpacing:
                                                                        1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Switch(
                                                              value:
                                                                  isInclusive,
                                                              activeColor: AppColor
                                                                  .greenDarkColor,
                                                              onChanged: (bool
                                                                  value) async {
                                                                // This is called when the user toggles the switch.
                                                                setState(() {
                                                                  isInclusive =
                                                                      value;
                                                                });
                                                                if (isInclusive ==
                                                                    true) {
                                                                  var command =
                                                                      "alx_m 0;";
                                                                  await deviceController
                                                                      .sendToDevice(
                                                                          command,
                                                                          WRITECHARACTERISTICS);
                                                                } else {
                                                                  var command =
                                                                      "alx_m 1;";
                                                                  await deviceController
                                                                      .sendToDevice(
                                                                          command,
                                                                          WRITECHARACTERISTICS);
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            // Min value input box
                                                            Expanded(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _minController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                focusNode:
                                                                    _minFocusNode,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          r'^-?\d{0,2}')),
                                                                  // Allow up to 2 digits with optional negative sign
                                                                ],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        DeviceSize.isTablet
                                                                            ? 24
                                                                            : 16),
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'Min',
                                                                  labelStyle: TextStyle(
                                                                      fontSize: DeviceSize
                                                                              .isTablet
                                                                          ? 28
                                                                          : 16),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    // Rounded corners (optional)
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: AppColor
                                                                          .greyLight,
                                                                      // Border color
                                                                      width:
                                                                          2.0, // Border width
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    // Rounded corners when focused
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: AppColor
                                                                          .greenDarkColor,
                                                                      // Border color when focused
                                                                      width:
                                                                          2.0, // Border width when focused
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 20),
                                                            Expanded(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _maxController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                focusNode:
                                                                    _maxFocusNode,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          r'^-?\d{0,2}')),
                                                                  // Allow up to 2 digits with optional negative sign
                                                                ],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        DeviceSize.isTablet
                                                                            ? 24
                                                                            : 16),
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'Max',
                                                                  labelStyle: TextStyle(
                                                                      fontSize: DeviceSize
                                                                              .isTablet
                                                                          ? 28
                                                                          : 16),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    // Rounded corners (optional)
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: AppColor
                                                                          .greyLight,
                                                                      // Border color
                                                                      width:
                                                                          2.0, // Border width
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    // Rounded corners when focused
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: AppColor
                                                                          .greenDarkColor,
                                                                      // Border color when focused
                                                                      width:
                                                                          2.0, // Border width when focused
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Theme(
                                                          data: ThemeData(
                                                            sliderTheme:
                                                                SliderThemeData(
                                                              rangeThumbShape: RoundRangeSliderThumbShape(
                                                                  enabledThumbRadius:
                                                                      DeviceSize
                                                                              .isTablet
                                                                          ? 18
                                                                          : 10),
                                                              trackHeight:
                                                                  DeviceSize
                                                                          .isTablet
                                                                      ? 16
                                                                      : 8,
                                                              thumbColor: AppColor
                                                                  .greenDarkColor,
                                                              // Change thumb color
                                                              activeTrackColor: isInclusive
                                                                  ? AppColor
                                                                      .greenDarkColor
                                                                  : Colors.green
                                                                      .withOpacity(
                                                                          0.3),
                                                              inactiveTrackColor:
                                                                  isInclusive
                                                                      ? Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              0.3)
                                                                      : AppColor
                                                                          .greenDarkColor,
                                                            ),
                                                          ),
                                                          child: RangeSlider(
                                                            values:
                                                                _currentRangeValues,
                                                            min: -90,
                                                            max: 90,
                                                            divisions: 180,
                                                            labels: RangeLabels(
                                                              _currentRangeValues
                                                                  .start
                                                                  .round()
                                                                  .toString(),
                                                              _currentRangeValues
                                                                  .end
                                                                  .round()
                                                                  .toString(),
                                                            ),
                                                            onChanged: (RangeValues
                                                                values) async {
                                                              HapticFeedback
                                                                  .lightImpact();
                                                              setState(() {
                                                                _currentRangeValues =
                                                                    values;
                                                                _minController
                                                                        .text =
                                                                    values.start
                                                                        .toStringAsFixed(
                                                                            0);
                                                                _maxController
                                                                        .text =
                                                                    values.end
                                                                        .toStringAsFixed(
                                                                            0);
                                                              });
                                                              double
                                                                  startValue =
                                                                  values.start;
                                                              double endValue =
                                                                  values.end;

                                                              String
                                                                  commandMin =
                                                                  "alx_min: ${sin(startValue * pi / 180)};";
                                                              String
                                                                  commandMax =
                                                                  "alx_max: ${sin(endValue * pi / 180)};";

                                                              // Call a function to send the commands to the device
                                                              await deviceController
                                                                  .sendToDevice(
                                                                      commandMin,
                                                                      WRITECHARACTERISTICS);
                                                              await deviceController
                                                                  .sendToDevice(
                                                                      commandMax,
                                                                      WRITECHARACTERISTICS);
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const Divider(),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Text(
                                                                'Right Band Range',
                                                                style: TextStyle(
                                                                    color: AppColor
                                                                        .greenDarkColor,
                                                                    fontSize:
                                                                        14.sp,
                                                                    letterSpacing:
                                                                        1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Switch(
                                                              value:
                                                                  isInclusiveRight,
                                                              activeColor: AppColor
                                                                  .greenDarkColor,
                                                              onChanged: (bool
                                                                  value) async {
                                                                // This is called when the user toggles the switch.
                                                                setState(() {
                                                                  isInclusiveRight =
                                                                      value;
                                                                });
                                                                if (isInclusiveRight ==
                                                                    true) {
                                                                  var command =
                                                                      "arx_m 0;";
                                                                  await deviceController
                                                                      .sendToDevice(
                                                                          command,
                                                                          WRITECHARACTERISTICS);
                                                                } else {
                                                                  var command =
                                                                      "arx_m 1;";
                                                                  await deviceController
                                                                      .sendToDevice(
                                                                          command,
                                                                          WRITECHARACTERISTICS);
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            // Min value input box
                                                            Expanded(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _minControllerRight,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                focusNode:
                                                                    _minFocusNodeRight,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          r'^-?\d{0,2}')),
                                                                  // Allow up to 2 digits with optional negative sign
                                                                ],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        DeviceSize.isTablet
                                                                            ? 24
                                                                            : 16),
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'Min',
                                                                  labelStyle: TextStyle(
                                                                      fontSize: DeviceSize
                                                                              .isTablet
                                                                          ? 28
                                                                          : 16),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    // Rounded corners (optional)
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: AppColor
                                                                          .greyLight,
                                                                      // Border color
                                                                      width:
                                                                          2.0, // Border width
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    // Rounded corners when focused
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: AppColor
                                                                          .greenDarkColor,
                                                                      // Border color when focused
                                                                      width:
                                                                          2.0, // Border width when focused
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 20),
                                                            Expanded(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _maxControllerRight,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                focusNode:
                                                                    _maxFocusNodeRight,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          r'^-?\d{0,2}')),
                                                                  // Allow up to 2 digits with optional negative sign
                                                                ],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        DeviceSize.isTablet
                                                                            ? 24
                                                                            : 16),
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'Max',
                                                                  labelStyle: TextStyle(
                                                                      fontSize: DeviceSize
                                                                              .isTablet
                                                                          ? 28
                                                                          : 16),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    // Rounded corners (optional)
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: AppColor
                                                                          .greyLight,
                                                                      // Border color
                                                                      width:
                                                                          2.0, // Border width
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    // Rounded corners when focused
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: AppColor
                                                                          .greenDarkColor,
                                                                      // Border color when focused
                                                                      width:
                                                                          2.0, // Border width when focused
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Theme(
                                                            data: ThemeData(
                                                              sliderTheme:
                                                                  SliderThemeData(
                                                                rangeThumbShape: RoundRangeSliderThumbShape(
                                                                    enabledThumbRadius:
                                                                        DeviceSize.isTablet
                                                                            ? 18
                                                                            : 10),
                                                                trackHeight:
                                                                    DeviceSize
                                                                            .isTablet
                                                                        ? 16
                                                                        : 8,
                                                                thumbColor: AppColor
                                                                    .greenDarkColor,
                                                                // Change thumb color
                                                                activeTrackColor: isInclusiveRight
                                                                    ? AppColor
                                                                        .greenDarkColor
                                                                    : Colors
                                                                        .green
                                                                        .withOpacity(
                                                                            0.3),
                                                                inactiveTrackColor: isInclusiveRight
                                                                    ? Colors
                                                                        .green
                                                                        .withOpacity(
                                                                            0.3)
                                                                    : AppColor
                                                                        .greenDarkColor,
                                                              ),
                                                            ),
                                                            child: RangeSlider(
                                                              values:
                                                                  _currentRangeValuesRight,
                                                              min: -90,
                                                              max: 90,
                                                              divisions: 180,
                                                              labels:
                                                                  RangeLabels(
                                                                _currentRangeValuesRight
                                                                    .start
                                                                    .round()
                                                                    .toString(),
                                                                _currentRangeValuesRight
                                                                    .end
                                                                    .round()
                                                                    .toString(),
                                                              ),
                                                              onChanged:
                                                                  (RangeValues
                                                                      values) async {
                                                                HapticFeedback
                                                                    .lightImpact();
                                                                setState(() {
                                                                  _currentRangeValuesRight =
                                                                      values;
                                                                  _minControllerRight
                                                                          .text =
                                                                      values
                                                                          .start
                                                                          .toStringAsFixed(
                                                                              0);
                                                                  _maxControllerRight
                                                                          .text =
                                                                      values.end
                                                                          .toStringAsFixed(
                                                                              0);
                                                                });
                                                                double
                                                                    startValue =
                                                                    values
                                                                        .start;
                                                                double
                                                                    endValue =
                                                                    values.end;
                                                                String
                                                                    commandMin =
                                                                    "arx_min: ${sin(startValue * pi / 180)};";
                                                                String
                                                                    commandMax =
                                                                    "arx_max: ${sin(endValue * pi / 180)};";
                                                                await deviceController
                                                                    .sendToDevice(
                                                                        commandMin,
                                                                        WRITECHARACTERISTICS);
                                                                await deviceController
                                                                    .sendToDevice(
                                                                        commandMax,
                                                                        WRITECHARACTERISTICS);
                                                              },
                                                            )),
                                                      ],
                                                    ),

                                                    // Input Fields for manual entry with validation
                                                    const SizedBox(height: 20),
                                                    // Display the current range values
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            // const ActiveInactiveButtons(),
                                            // const SizedBox(height: 10)
                                          ]),
                                        ),
                                        Visibility(
                                          visible: !AdvancedMode.modevisiable,
                                          child: const SizedBox(
                                            height: 45,
                                          ),
                                        ),

                                        // const SizedBox(
                                        //   height: 5,
                                        // ),

                                        if (DeviceSize.isTablet)
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        Row(
                                          children: [
                                            Text(
                                              "Disconnect Device",
                                              style: TextStyle(
                                                color: AppColor.greenDarkColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: DeviceSize.isTablet
                                                    ? 18.h
                                                    : 16.sp,
                                              ),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  Analytics.addClicks(
                                                      "DisconnectButton",
                                                      DateTime.timestamp());
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        ConfirmationBox(
                                                      title:
                                                          'Disconnect device',
                                                      content:
                                                          'Are sure want to disconnect device?',
                                                      btnText: 'Disconnect',
                                                      onConfirm: () {
                                                        deviceController
                                                            .disconnectDevice(
                                                                deviceController
                                                                    .connectedDevice);
                                                      },
                                                    ),
                                                  );
                                                  //
                                                },
                                                icon: Icon(
                                                  Icons.bluetooth_disabled,
                                                  size: DeviceSize.isTablet
                                                      ? 36
                                                      : 24,
                                                )),
                                          ],
                                        ),
                                        if (DeviceSize.isTablet)
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        Divider(
                                          thickness:
                                              DeviceSize.isTablet ? 8 : 4,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (DeviceSize.isTablet)
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        Row(
                                          children: [
                                            Text(
                                              "Connect Device : ${Device.name}",
                                              style: TextStyle(
                                                color: AppColor.greenDarkColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: DeviceSize.isTablet
                                                    ? 18.h
                                                    : 16.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (DeviceSize.isTablet)
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          thickness:
                                              DeviceSize.isTablet ? 8 : 4,
                                        ),

                                        Visibility(
                                          visible: AdvancedMode.modevisiable,
                                          child: const SizedBox(
                                            height: 25,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Text("No data by device");
                          }
                      }
                    },
                    future: metricsFuture,
                  );
                }),
          ),
        ));
  }
}
