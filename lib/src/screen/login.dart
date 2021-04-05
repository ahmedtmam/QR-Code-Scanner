import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../common/commons.dart';
import '../provider/providers.dart';
import '../widget/widgets.dart';
import 'screens.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  //variables
  TextFieldModel email, password;
  final formKey = GlobalKey<FormState>();
  final authProvider = AuthProvider();

  //init functions
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      if (authProvider.check()) {
        switch (authProvider.accountType()) {
          case AccountType.security:
            pushClear(context, QrScanner());
            break;
          case AccountType.manager:
            pushClear(context, HomeManager());
            break;
          case AccountType.employee:
            pushClear(context, Home());
            break;
        }
      }
    });
    super.initState();
  }

  void initModels() {
    email = email ??
        TextFieldModel(
          errorMsg: 'please enter valid email',
          keyboardType: TextInputType.emailAddress,
          label: 'email',
          regex: emailRegex,
          width: width(context, .6),
          onSubmit: () => FocusScope.of(context).nextFocus(),
        );

    password = password ??
        TextFieldModel(
          errorMsg: 'please enter valid password',
          keyboardType: TextInputType.visiblePassword,
          label: 'password',
          regex: passwordRegex,
          width: width(context, .6),
          onSubmit: () => FocusScope.of(context).unfocus(),
        );
  }

  //logic functions
  void _login() {
    if (!formKey.currentState.validate()) return;
    authProvider?.login(
      email.text,
      password.text,
      (state, {error}) {
        switch (state) {
          case AuthProviderState.start:
            BotToast.showLoading();
            break;
          case AuthProviderState.success:
            if (authProvider.accountType() == AccountType.security)
              pushClear(context, QrScanner());
            else
              pushClear(context, Home());
            break;
          case AuthProviderState.fail:
            BotToast.showSimpleNotification(
              title: 'error please try again later',
              subTitle: error,
              duration: Duration(seconds: 3),
            );
            break;
          case AuthProviderState.finish:
            BotToast.closeAllLoading();
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initModels();
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: ScrollableColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: height(context, 0.4),
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyTextField(model: email),
                    SizedBox(height: 10),
                    MyTextField(model: password),
                    SizedBox(height: 20),
                    MyButton(text: 'LogIn', onPress: _login),
                    SizedBox(height: 60),
                    MyButton(
                      text: 'LogIn as Student ? ',
                      onPress: () {
                        push(context, QrGenerator());
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
