import 'package:cloud_firestore/cloud_firestore.dart';

// userId, studentId, type ,data
class EventTracker{
  String id;
  String userId;
  String studentId;
  String type;
  Timestamp date;

  EventTracker(this.userId, this.studentId, this.type, this.date);

  EventTracker.fromDocumentSnapshot(DocumentSnapshot doc){
    this.id = doc.id;
    var map = doc.data();
    this.userId = map['userId'];
    this.studentId = map['studentId'];
    this.type = map['type'];
    this.date = map['date'];
  }


  toMap() => {
    'userId' : this.userId,
    'studentId' : this.studentId,
    'type' : this.type,
    'date' : this.date,
  };

}

enum EventType{
  add, edit, remove, allow
}