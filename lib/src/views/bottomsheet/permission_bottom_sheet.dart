// import 'package:flutter/material.dart';
// import 'package:walk/src/controllers/device_controller.dart';
// import 'package:walk/src/utils/custom_notification.dart';

// void permissionBottomSheet(BuildContext context) {
//   WidgetsBinding.instance.addPostFrameCallback((_) async {
//     bool customTileExpanded = false;

//     await showModalBottomSheet(
//         backgroundColor: Colors.blue.shade100,
//         context: context,
//         builder: (builder) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Wrap(
//               children: [
//                 Card(
//                   child: ExpansionTile(
//                     title: const Text('Bluetooth Permission'),
//                     trailing: Icon(
//                       customTileExpanded
//                           ? Icons.arrow_drop_down_circle
//                           : Icons.arrow_drop_down,
//                     ),
//                     children: [
//                       ListTile(
//                         title: Text('This is tile number 2'),
//                         trailing: TextButton(
//                           onPressed: () {
//                             DeviceController(
//                               performScan: false,
//                               checkPrevconnection: true,
//                             );
//                           },
//                           child: Text("data"),
//                         ),
//                       ),
//                     ],
//                     onExpansionChanged: (bool expanded) {
//                       customTileExpanded = expanded;
//                     },
//                   ),
//                 ),
//                 Card(
//                   child: ExpansionTile(
//                     title: Text('Location Permission'),
//                     trailing: Icon(
//                       customTileExpanded
//                           ? Icons.arrow_drop_down_circle
//                           : Icons.arrow_drop_down,
//                     ),
//                     children: <Widget>[
//                       ListTile(
//                         title: Text('This is tile number 2'),
//                         trailing: TextButton(
//                           onPressed: () {
//                             DeviceController().checkLocationPremission();
//                           },
//                           child: Text("data"),
//                         ),
//                       ),
//                     ],
//                     onExpansionChanged: (bool expanded) {
//                       customTileExpanded = expanded;
//                     },
//                   ),
//                 ),
//                 Card(
//                   child: ExpansionTile(
//                     title: const Text('Notification Permission'),
//                     trailing: Icon(
//                       customTileExpanded
//                           ? Icons.arrow_drop_down_circle
//                           : Icons.arrow_drop_down,
//                     ),
//                     children: <Widget>[
//                       ListTile(
//                         title: Text('This is tile number 2'),
//                         trailing: TextButton(
//                           onPressed: () {
//                             NotificationService.notificationPermission(context);
//                           },
//                           child: Text("data"),
//                         ),
//                       ),
//                     ],
//                     onExpansionChanged: (bool expanded) {
//                       customTileExpanded = expanded;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   });
// }
