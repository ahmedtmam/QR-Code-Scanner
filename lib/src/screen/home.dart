import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../common/commons.dart';
import '../model/student.dart';
import '../provider/providers.dart';
import '../widget/widgets.dart';
import 'screens.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextFieldModel search;
  var students = <Student>[];
  final auth = AuthProvider();
  final store = StoreProvider();

  @override
  Widget build(BuildContext context) {
    search = search ??
        TextFieldModel(
          label: 'student code',
          onSubmit: () => FocusScope.of(context).unfocus(),
          width: double.infinity,
          keyboardType: TextInputType.number,
          errorMsg: null,
          regex: null,
        );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await auth.signOut();
                      pushClear(context, LogIn());
                    }),
                Expanded(
                  child: MyTextField(
                    model: search,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    var searchCode = search.text.trim();
                    if (searchCode.isEmpty) return;
                    var student = students.singleWhere(
                        (element) => element.code == searchCode,
                        orElse: () => null);
                    if (student == null) {
                      BotToast.showSimpleNotification(
                          title: 'Student Not Fond');
                      return;
                    }
                    push(
                        context,
                        ManageStudent(
                          student: student,
                        )).then((value) {
                      setState(() {});
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          push(context, ManageStudent(student: Student())).then((value) {
            setState(() {});
          });
        },
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: store.getAllStudents(),
          builder: (context, AsyncSnapshot<List<Student>> snapshot) {
            if (snapshot.hasData) {
              students = snapshot.data;
              if (students.isEmpty)
                return Center(
                  child: Text('there is no students in database yet'),
                );
              return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    var student = students[index];
                    return StudentCard(
                      student: student,
                      delete: () {
                        showDialog(context: context, builder: (context) {
                          return SimpleDialog(
                            contentPadding: EdgeInsets.only(top: 8, bottom: 0, left: 8, right: 8),
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
                                            onPressed: (){
                                          store.deleteStudent(student.id).then((value) {
                                            setState(() {});
                                            pop(context);
                                          });
                                        }, child: Text('yes')),
                                        FlatButton(onPressed: () => pop(context), child: Text('no')),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        });
                      },
                      edit: () {
                        push(context, ManageStudent(student: student))
                            .then((value) {
                          setState(() {});
                        });
                      },
                    );
                  });
            } else
              return Center(child: Text('Loading ...'));
          },
        ),
      ),
    );
  }
}
