import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String emailRegex = '^[a-zA-Z1-9_]{3,}@.+\\.com\$';
String passwordRegex = '^[a-zA-Z1-9_]{8,}\$';

double width(BuildContext context, double percentage) =>
    MediaQuery.of(context).size.width * percentage;

double height(BuildContext context, double percentage) =>
    MediaQuery.of(context).size.height * percentage;
