import 'package:barcode_widget/barcode_widget.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/src/common/commons.dart';
import 'package:qr_code/src/provider/providers.dart';
import 'package:qr_code/src/widget/widgets.dart';

class QrGenerator extends StatefulWidget {
  @override
  _QrGeneratorState createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  String qrData;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var pref = SharedProvider();
      qrData = await pref.getLastData();
      setState(() {
        if(qrData != null) qrModel.text = qrData;
      });
    });
    super.initState();
  }

  TextFieldModel qrModel;

  @override
  Widget build(BuildContext context) {
    qrModel = qrModel ??
        TextFieldModel(
            label: 'qr data',
            onSubmit: () => FocusScope.of(context).unfocus(),
            regex: '^[0-9]{14,}\$',
            errorMsg: '',
            width: width(context, 0.7),
            keyboardType: TextInputType.number,

        );

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (qrData != null)
                BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  color: black,
                  data: qrData,
                  width: 200,
                  height: 200,
                ),
              if(qrData != null) SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyTextField(
                        model: qrModel,
                      ),
                    ),
                  ),
                 MyButton(text: 'Generate', onPress: generateCode,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void generateCode() {
    if(!RegExp(qrModel.regex).hasMatch(qrModel.text)){
      BotToast.showSimpleNotification(title: 'please enter valid qr data', subTitle: 'your ssn + your student code');
      return;
    }
    qrData = qrModel.text;
    SharedProvider().setData(qrData);
    setState(() {

    });
  }
}
