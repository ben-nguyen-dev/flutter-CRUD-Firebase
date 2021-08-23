import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_demo/models/student.dart';
import 'package:project_demo/models/user.dart';
import 'package:project_demo/screens/create_student/components/edit_student_widget.dart';
import 'package:project_demo/services/auth.dart';
import 'package:project_demo/services/database.dart';
import 'package:provider/provider.dart';

class CreateStudent extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService().profile,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PopupMenuButton(
                  child: const Icon(Icons.person),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text("Logout"),
                          onTap: () async {
                            await _auth.signOut();
                          },
                        ),
                        const PopupMenuItem(child: Text("My profile")),
                      ]),
            )
          ],
        ),
        body: StreamProvider<List<Student>?>.value(
            value: DatabaseService(uid: user!.uid).allStudent,
            initialData: null,
            child: CreateStudentWidget()),
      ),
    );
  }
}
