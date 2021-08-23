import 'package:flutter/material.dart';
import 'package:project_demo/models/student.dart';
import 'package:project_demo/screens/create_student/views/edit_student.dart';
import 'package:project_demo/services/database.dart';

class StudentItem extends StatefulWidget {
  final Student student;
  const StudentItem({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentItem> createState() => _StudentItemState();
}

class _StudentItemState extends State<StudentItem> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.student.studentAvatar),
              radius: 30.0,
            ),
            title: Text(widget.student.studentName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Text("ID: ${widget.student.studentId}"),
                Text("Email: ${widget.student.studentEmail}"),
                Text("GPA: ${widget.student.studentGPA}"),
              ],
            ),
            trailing: PopupMenuButton(
                child: const Icon(Icons.more_vert),
                onSelected: (result) async {
                  if (result == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditStudent(studentEdit: widget.student)),
                    );
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text("Remove"),
                        value: 0,
                        onTap: () async {
                          await DatabaseService()
                              .deleteStudent(widget.student.id);
                        },
                      ),
                      PopupMenuItem(
                        child: Text("Edit"),
                        value: 1,
                        onTap: () async {},
                      ),
                    ]),
          ),
        ),
      ),
    );
  }
}
