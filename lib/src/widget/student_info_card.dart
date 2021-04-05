
import 'package:flutter/material.dart';
import 'package:qr_code/src/common/commons.dart';
import 'package:qr_code/src/model/student.dart';

class StudentInfoCard extends StatelessWidget {
  final Student student;

  const StudentInfoCard({Key key, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                student.image,
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 5),
            Text(student.name),
            Text('code: ' + student.code),
            SizedBox(height: 5),
            Text('ssn: ' + student.ssn),
            SizedBox(height: 5),
            Text('faculty: ' + student.faculty),
            SizedBox(width: 10),
            Text('grade: ' + student.grade),
            SizedBox(height: 5),
            Text('phone number: ' + student.phone),
            SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: GestureDetector(
                onTap: () => pop(context),
                child: Icon(
                  Icons.check,
                  color: white,
                  size: 50.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
