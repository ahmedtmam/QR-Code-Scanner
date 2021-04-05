import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/src/model/event.dart';
import 'package:qr_code/src/provider/providers.dart';

import '../common/commons.dart';
import '../model/student.dart';
import '../widget/student_info_card.dart';

class StudentViewer extends StatelessWidget {
  final String studentCode;
  final store = StoreProvider();

  StudentViewer(this.studentCode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: store.getStudentById(studentCode),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Text('loading ...'),
              );
            else {
              var doc = snapshot.data;
              if (doc.exists) {
                var event = EventTracker(AuthProvider().uid, studentCode,
                    EventType.allow.toString(), Timestamp.now());
                store.addEvent(event);

                return StudentInfoCard(
                  student: Student.fromDocumentSnapshot(doc),
                );
              } else {
                return Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration:
                        BoxDecoration(color: red, shape: BoxShape.circle),
                    child: GestureDetector(
                      onTap: () => pop(context),
                      child: Icon(
                        Icons.error,
                        size: 50,
                        color: white,
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
