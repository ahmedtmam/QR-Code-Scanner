import 'package:flutter/material.dart';
import 'package:qr_code/src/model/student.dart';

import '../common/commons.dart';

class StudentCard extends StatelessWidget {
  final void Function() delete, edit;
  final Student student;

  const StudentCard({Key key, this.delete, this.edit, this.student})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(student.image),
                ),
                flex: 1),
            SizedBox(width: 10),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text('code: ' + student.code),
                    SizedBox(height: 4),
                    Text('ssn: ' + student.ssn),
                    SizedBox(height: 4),
                    Text('faculty: ' + student.faculty),
                    Text('grade: ' + student.grade),
                    SizedBox(height: 4),
                    Text('phone number: ' + student.phone),
                  ],
                ),
                flex: 3),
            Column(
              children: [
                IconButton(icon: Icon(Icons.edit), onPressed: edit),
                IconButton(
                    icon: Icon(Icons.delete, color: red), onPressed: delete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
