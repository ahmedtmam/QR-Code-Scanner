import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// id, code, name, image, phone, ssn, faculty, grade
class Student {
  String id, code, name, image, phone, ssn, faculty, grade;

  Student();

  Student.fromDocumentSnapshot(DocumentSnapshot doc){
    this.id = doc.id;
    var map = doc.data();
    this.code = map['code'];
    this.name = map['name'];
    this.image = map['image'];
    this.phone = map['phone'];
    this.ssn = map['ssn'];
    this.faculty = map['faculty'];
    this.grade = map['grade'];
  }

  toMap() => {
    'code' : this.code,
    'name' : this.name,
    'image' : this.image,
    'phone' : this.phone,
    'ssn' : this.ssn,
    'faculty' : this.faculty,
    'grade' : this.grade,
  };

  @override
  String toString() {
    return jsonEncode(toMap());
  }

}
