import 'package:flutter/material.dart';
import 'package:qr_code/src/common/commons.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function() onPress;

  const MyButton({Key key, this.text, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: black),
            ]
        ),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}