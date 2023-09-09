// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

/// Initializing new Isolate for background and foreground service
Future<void> initializeService() async {
  try {
    final service = FlutterBackgroundService();

    await service.configure(
        iosConfiguration: IosConfiguration(
          onForeground: onStartService,
          onBackground: iosBackgroundService,
        ),
        androidConfiguration: AndroidConfiguration(
            onStart: onStartService, isForegroundMode: true));
  } catch (e) {
    log('init foreground service error: $e');
  }
}

// Future<void> initializeBackgroundService() async {
//   try {
//     final service = FlutterBackgroundService();

//     await service.configure(
//         iosConfiguration: IosConfiguration(
//           onForeground: onStartBackground,
//           onBackground: iosBackgroundService,
//         ),
//         androidConfiguration: AndroidConfiguration(
//             onStart: onStartBackground,
//             isForegroundMode: false,
//             autoStart: true));
//   } catch (e) {
//     log('init background service error: $e');
//   }
// }

/// OnStart configuration for foreground service for android
/// Execute foreground code here
@pragma('vm:entry-point')
onStartService(ServiceInstance service) {
  try {
    /// for safely initializing dart isolate
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      /// sets foreground service
      service.on('setForegroundService').listen((event) {
        service.setAsForegroundService();
      });

      /// sets background service
      service.on('setBackgroundService').listen((event) {
        service.setAsBackgroundService();
      });
    }

    /// Stops service
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
    int l = 0;
    int r = 0;
    int s = 0;
    int c = 0;

    Timer.periodic(const Duration(seconds: 20), (timer) async {
      if (service is AndroidServiceInstance) {
        /// Execute forground code here
        if (await service.isForegroundService()) {
          log('foreground service on');
          l++;
          r++;
          service.setForegroundNotificationInfo(
              title: 'Battery', content: 'L: $l%\nR: $r%');
        }
      }

      /// Execute background code here
      s--;
      c--;

      log('background service:- L: $s \tR: $c');
      service.invoke('update');
    });
  } catch (e) {
    log('OnStart foreground function error: $e');
  }
}

/// OnStart configuration for background service for android
/// Execute background code here
// @pragma('vm:entry-point')
// onStartBackground(ServiceInstance service) {
//   try {
//     /// for safely initializing dart isolate
//     DartPluginRegistrant.ensureInitialized();

//     if (service is AndroidServiceInstance) {
//       /// sets foreground service
//       // service.on('setForegroundService').listen((event) {
//       //   service.setAsForegroundService();
//       // });

//       /// sets background service
//       service.on('setBackgroundService').listen((event) {
//         service.setAsBackgroundService();
//       });
//     }

//     /// Stops service
//     service.on('stopService').listen((event) {
//       service.stopSelf();
//     });
//     int l = 0;
//     int r = 0;
//     int s = 0;
//     int c = 0;

//     Timer.periodic(const Duration(seconds: 20), (timer) async {
//       // if (service is AndroidServiceInstance) {
//       //   /// Execute forground code here
//       //   if (await service.isForegroundService()) {
//       //     log('foreground service on');
//       //     l++;
//       //     r++;
//       //     service.setForegroundNotificationInfo(
//       //         title: 'Battery', content: 'L: $l%\nR: $r%');
//       //   }
//       // }

//       /// Execute background code here
//       s--;
//       c--;

//       log('background service:- L: $s \tR: $c');
//       service.invoke('update');
//     });
//   } catch (e) {
//     log('OnStart background function error: $e');
//   }
// }

/// IOS background function excutes here
@pragma('vm:entry-point')
Future<bool> iosBackgroundService(ServiceInstance service) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  } catch (e) {
    log('iosBackground function error: $e');
    return false;
  }
}
