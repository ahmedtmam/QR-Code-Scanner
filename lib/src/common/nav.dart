import 'package:flutter/material.dart';

Future push(BuildContext context, Widget screen) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

void pushReplace(BuildContext context, Widget screen) =>
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));

void pushClear(BuildContext context, Widget screen) =>
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => screen), (route) => false);

void pop(BuildContext context) => Navigator.pop(context);
