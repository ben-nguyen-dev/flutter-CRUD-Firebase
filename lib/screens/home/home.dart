import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_demo/models/student.dart';
import 'package:project_demo/models/user.dart';
import 'package:project_demo/screens/create_student/views/create_student.dart';
import 'package:project_demo/screens/home/list_student.dart';
import 'package:project_demo/services/auth.dart';
import 'package:project_demo/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  // Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();
  static const List<Student> initialData = [];

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
                      ]),
            )
          ],
        ),
        body: StreamProvider<List<Student>>.value(
            value: DatabaseService(uid: user!.uid).allStudent,
            initialData: initialData,
            child: const ListStudent()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateStudent()),
            );
          },
          tooltip: 'Create student',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
