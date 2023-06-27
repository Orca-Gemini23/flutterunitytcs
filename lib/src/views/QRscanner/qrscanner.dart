import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walk/src/constants/app_color.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appBarColor,
        title: const Text("Scan QR"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColor.bgColor,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: _buildQrView(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: AppColor.purpleColor.withOpacity(1),
          overlayColor: AppColor.bgColor.withOpacity(.8),
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 15,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      HapticFeedback.heavyImpact();
      controller.pauseCamera();
      AwesomeDialog(
          dismissOnTouchOutside: false,
          context: context,
          title: "Scanner",
          titleTextStyle:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          desc:
              "QR scanned want to proceed to ${String.fromCharCodes(result!.code!.codeUnits)}",
          descTextStyle: const TextStyle(fontSize: 16),
          btnOk: ElevatedButton(
            child: const Text("Yes , Take me to the link"),
            onPressed: () async {
              String link = String.fromCharCodes(result!.code!.codeUnits);
              if (await canLaunchUrl(Uri.parse(link))) {
                await launchUrl(Uri.parse(link),
                    mode: LaunchMode.externalNonBrowserApplication);
              } else {
                Fluttertoast.showToast(msg: "Cannot Launch Url !!!");
              }
              controller.resumeCamera();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          btnCancel: ElevatedButton(
            child: const Text("Rescan"),
            onPressed: () {
              controller.resumeCamera();
              Navigator.of(context, rootNavigator: true).pop();

              setState(() {});
            },
          )).show();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('PermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
