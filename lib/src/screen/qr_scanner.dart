import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code/src/common/commons.dart';
import 'package:qr_code/src/provider/providers.dart';
import 'package:qr_code/src/screen/screens.dart';
import 'package:qr_code/src/widget/widgets.dart';

class QrScanner extends StatelessWidget {
  final auth = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      text: 'sign out',
                      onPress: () async {
                        await auth.signOut();
                        pushClear(context, LogIn());
                      },
                    ),
                  )
                ],
              )),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyButton(
                      text: 'start scanning',
                      onPress: () => startScanning(context),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  void startScanning(BuildContext context) async {
    try {
      var data = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", false, ScanMode.DEFAULT);

      if (data == null) {
        BotToast.showSimpleNotification(title: 'please try again later');
        return;
      }
      push(context, StudentViewer(data));
    } catch (e) {
      print(e.toString());
      BotToast.showSimpleNotification(title: 'please try again later');
    }
  }
}
