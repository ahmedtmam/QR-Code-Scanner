import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/src/common/commons.dart';
import 'package:qr_code/src/model/student.dart';
import 'package:qr_code/src/provider/providers.dart';
import 'package:qr_code/src/widget/widgets.dart';

// ignore: must_be_immutable
class ManageStudent extends StatefulWidget {
  Student student;

  ManageStudent({this.student});

  @override
  _ManageStudentState createState() => _ManageStudentState();
}

class _ManageStudentState extends State<ManageStudent> {
  ImageData studentImage = ImageData(null, false);

  var formKey = GlobalKey<FormState>();

  final store = StoreProvider();

  TextFieldModel name, ssn, phone, faculty, grade, code;

  get isEdit => widget.student.id != null;

  Student get student => widget.student;

  @override
  Widget build(BuildContext context) {
    initFieldModel(context);
    if (isEdit) loadStudentData();
    return Scaffold(
      floatingActionButton: !isEdit
          ? FloatingActionButton(
              heroTag: 'btn1',
              child: Icon(Icons.check),
              onPressed: action,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'btn2',
                  backgroundColor: red,
                  child: Icon(Icons.delete),
                  onPressed: () => delete(context),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  heroTag: 'btn3',
                  child: Icon(Icons.check),
                  onPressed: action,
                ),
              ],
            ),
      body: ScrollableColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          ImageGetter(studentImage),
          SizedBox(height: 10),
          Form(
            key: formKey,
            child: Column(
              children: [
                MyTextField(model: name),
                MyTextField(model: phone),
                MyTextField(model: faculty),
                MyTextField(model: grade),
                MyTextField(
                  model: ssn,
                  isEdit: isEdit,
                ),
                MyTextField(
                  model: code,
                  isEdit: isEdit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void loadStudentData() {
    studentImage = ImageData(student.image, true);
    name.text = student.name;
    ssn.text = student.ssn;
    phone.text = student.phone;
    faculty.text = student.faculty;
    grade.text = student.grade;
    code.text = student.code;
  }

  void action() {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState.validate()) return;
    if (studentImage.url == null) {
      BotToast.showSimpleNotification(title: 'Please select an image');
      return;
    }

    collectStudentData();

    !isEdit
        ? store.uploadNewStudent(student, studentImage, handleState)
        : store.editStudentData(student, studentImage, handleState);
  }

  void handleState(state, {error}) {
    switch (state) {
      case StoreState.start:
        BotToast.showLoading();
        break;
      case StoreState.success:
        pop(context);
        break;
      case StoreState.fail:
        BotToast.showSimpleNotification(
          title: 'error please try again later',
          subTitle: error,
        );
        break;
      case StoreState.finish:
        BotToast.closeAllLoading();
        break;
    }
  }

  void collectStudentData() {
    student.code = code.text;
    student.ssn = ssn.text;
    student.phone = phone.text;
    student.grade = grade.text;
    student.faculty = faculty.text;
    student.name = name.text;
  }

  void initFieldModel(BuildContext context) {
    name = name ??
        TextFieldModel(
          label: 'name',
          onSubmit: () => FocusScope.of(context).nextFocus(),
          regex: '.{3,}',
          errorMsg: 'please enter valid name',
          width: width(context, 0.6),
          keyboardType: TextInputType.name,
        );
    ssn = ssn ??
        TextFieldModel(
          label: 'ssn',
          onSubmit: () => FocusScope.of(context).nextFocus(),
          regex: '^[0-9]{14}\$',
          errorMsg: 'please enter valid ssn',
          width: width(context, 0.6),
          keyboardType: TextInputType.number,
        );
    phone = phone ??
        TextFieldModel(
          label: 'phone',
          onSubmit: () => FocusScope.of(context).nextFocus(),
          regex: '^[0-9]{11}\$',
          errorMsg: 'please enter valid phone number',
          width: width(context, 0.6),
          keyboardType: TextInputType.phone,
        );
    faculty = faculty ??
        TextFieldModel(
          label: 'faculty',
          onSubmit: () => FocusScope.of(context).nextFocus(),
          regex: '.{3,}',
          errorMsg: 'please enter valid faculty name',
          width: width(context, 0.6),
          keyboardType: TextInputType.name,
        );
    grade = grade ??
        TextFieldModel(
          label: 'grade',
          onSubmit: () => FocusScope.of(context).nextFocus(),
          regex: '^[1-9]{1}\$',
          errorMsg: 'please enter valid grade number',
          width: width(context, 0.6),
          keyboardType: TextInputType.number,
        );
    code = code ??
        TextFieldModel(
          label: 'student code',
          onSubmit: () => FocusScope.of(context).unfocus(),
          regex: '[0-9]{4,}',
          errorMsg: 'please enter valid student code',
          width: width(context, 0.6),
          keyboardType: TextInputType.number,
        );
  }

  void delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(top: 8, bottom: 0, left: 8, right: 8),
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Are You Sure ?', style: TextStyle(fontSize: 25)),
                    SizedBox(height: 8),
                    Text('delete student \'${student.name}\''),
                    SizedBox(height: 2),
                    Text('with student code \'${student.code}\''),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                            onPressed: () {
                              store.deleteStudent(student.id).then((value) {
                                pop(context);
                                pop(context);
                              });
                            },
                            child: Text('yes')),
                        FlatButton(
                            onPressed: () => pop(context), child: Text('no')),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
