
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'common/commons.dart';
import 'screen/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        scaffoldBackgroundColor: white,
      ),
      home: LogIn(),
    );
  }
}
