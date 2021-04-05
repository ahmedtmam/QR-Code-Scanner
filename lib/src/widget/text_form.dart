import 'package:flutter/material.dart';

class TextFieldModel {
  final String label, regex, errorMsg;
  final double width;
  final Function() onSubmit;
  TextEditingController _controller = TextEditingController();
  final TextInputType keyboardType;

  String get text => _controller.text.trim();
  set text(String value) => _controller.value = TextEditingValue(text: value);

  TextFieldModel({
    @required this.label,
    @required this.onSubmit,
    @required this.regex,
    @required this.errorMsg,
    @required this.width,
    @required this.keyboardType,
  });
}

class MyTextField extends StatelessWidget {
 final TextFieldModel model;
 final bool isEdit;

  const MyTextField({
    Key key,
    this.isEdit = false,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: model.width,
      margin: EdgeInsets.only(bottom: 8),
      child: TextFormField(
        readOnly: isEdit,
        controller: model._controller,
        obscureText: model.keyboardType == TextInputType.visiblePassword,
        keyboardType: model.keyboardType,
        validator: (value) {
          var valid = RegExp(model.regex).hasMatch(value);
          if (!valid) return model.errorMsg;
          return null;
        },
        onEditingComplete: () {
          model.onSubmit?.call();
        },
        decoration: InputDecoration(
          labelText: model.label,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
