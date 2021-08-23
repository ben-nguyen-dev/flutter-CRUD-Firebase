import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:project_demo/models/student.dart';

class DatabaseService {
  final String? uid;
  final String? studentEmail;
  DatabaseService({this.uid, this.studentEmail});
//  collection reference user
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

//  collection reference my student
  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection("myStudent");

//  update User
  Future addUser(String name, String email) async {
    return await userCollection.doc(uid).set({"name": name, "email": email});
  }

//  get data user stream
  Stream<QuerySnapshot> get profile {
    return userCollection.snapshots();
  }

//  upload file
  Future uploadImageToFirebase(String? filePath, String? fileName) async {
    if (filePath == null) return;

    File file = File(filePath);
    try {
      // upload image
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/student_avatar/$fileName')
          .putFile(file);

      // get url image
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('uploads/student_avatar/$fileName')
          .getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("upload fail");
      return null;
    }
  }

//  create new student
  Future addNewStudent(String studentName, String studentId,
      String studentEmail, double studentGPA, String studentAvatar) async {
    try {
      await studentCollection.doc().set({
        "studentName": studentName,
        "studentId": studentId,
        "studentEmail": studentEmail,
        "studentGPA": studentGPA,
        "studentAvatar": studentAvatar,
        "uidUser": uid
      });

      return true;
    } catch (e) {
      return false;
    }
  }

//  update student
  Future updateStudent(
    String studentName,
    String studentId,
    String studentEmail,
    double studentGPA,
    String studentAvatar,
    String? id,
  ) async {
    try {
      await studentCollection.doc(id).update({
        "studentName": studentName,
        "studentId": studentId,
        "studentEmail": studentEmail,
        "studentGPA": studentGPA,
        "studentAvatar": studentAvatar,
        "uidUser": uid
      });
      return true;
    } catch (e) {
      return false;
    }
  }

//  delete student
  Future deleteStudent(String? id) async {
    if (id == null || id.isEmpty) return;
    try {
      studentCollection
          .doc(id)
          .delete()
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
      ;
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

//  list student
  List<Student> _studentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Student(
        studentEmail: doc["studentEmail"] ?? "",
        studentName: doc["studentName"] ?? "",
        studentId: doc["studentId"] ?? "",
        studentGPA: doc["studentGPA"] ?? 0,
        studentAvatar: doc["studentAvatar"] ?? "",
        id: doc.id,
      );
    }).toList();
  }

//  get all student
  Stream<List<Student>>? get allStudent {
    try {
      return studentCollection
          .where("uidUser", isEqualTo: uid)
          .snapshots()
          .map(_studentListFromSnapshot);
    } catch (e) {
      print("get all student fail");
      return null;
    }
  }
}
