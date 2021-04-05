import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code/src/model/event.dart';

import '../model/student.dart';
import '../widget/widgets.dart';
import 'providers.dart';

class StoreProvider {
  var _store = FirebaseFirestore.instance;
  CollectionReference get studentCollection => _store.collection('student');
  CollectionReference get eventCollection => _store.collection('event');

  void uploadNewStudent(
    Student student,
    ImageData image,
    Function(StoreState, {String error}) state,
  ) async {
    state(StoreState.start);
    var downloadLink = await StorageProvider().uploadImage(image);
    if (downloadLink == null) {
      state(StoreState.fail,
          error: 'can\'t upload image now please try again later');
      state(StoreState.finish);
      return;
    }

    student.image = downloadLink;
    try {
      await studentCollection
          .doc(student.ssn + student.code)
          .set(student.toMap());
      var event = EventTracker(AuthProvider().uid, student.ssn + student.code,
          EventType.add.toString(), Timestamp.now());
      addEvent(event);
      state(StoreState.success);
    } catch (e) {
      state(StoreState.fail, error: e.toString());
    } finally {
      state(StoreState.finish);
    }
  }

  void editStudentData(
    Student student,
    ImageData image,
    Function(StoreState, {String error}) state,
  ) async {
    state(StoreState.start);
    var downloadLink = image.fromServer
        ? image.url
        : await StorageProvider().uploadImage(image);
    if (downloadLink == null) {
      state(StoreState.fail,
          error: 'can\'t upload image now please try again later');
      state(StoreState.finish);
      return;
    }

    student.image = downloadLink;
    try {
      await studentCollection.doc(student.id).update(student.toMap());
      state(StoreState.success);
      var event = EventTracker(AuthProvider().uid, student.ssn + student.code,
          EventType.edit.toString(), Timestamp.now());
      addEvent(event);
    } catch (e) {
      state(StoreState.fail, error: e.toString());
    } finally {
      state(StoreState.finish);
    }
  }

  Future<List<Student>> getAllStudents() async {
    var students = <Student>[];
    try {
      var querySnapshot = await studentCollection.get();
      for (var doc in querySnapshot.docs) {
        students.add(Student.fromDocumentSnapshot(doc));
      }
      return students;
    } catch (e) {
      return students;
    }
  }

  Future<void> deleteStudent(String studentId) {
    var event = EventTracker(
        AuthProvider().uid, studentId, EventType.remove.toString(), Timestamp.now());
    addEvent(event);
    return studentCollection.doc(studentId).delete();
  }

  Future<DocumentSnapshot> getStudentById(String id) =>
      studentCollection.doc(id).get();

  void addEvent(EventTracker event) {
    eventCollection.add(event.toMap());
  }
}

enum StoreState { start, success, fail, finish }