import 'package:cloud_firestore/cloud_firestore.dart';

class Employee{
  String id, email, displayName;

  Employee.fromDocumentSnapshot(DocumentSnapshot doc){
    this.id = doc.id;
    var map = doc.data();
    this.email = map['email'];
    this.displayName = map['displayName'];
  }
  toMap() => {
    'email' : this.email,
    'displayName' : this.displayName,
  };

}