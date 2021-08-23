import 'package:flutter/material.dart';
import 'package:project_demo/models/student.dart';
import 'package:project_demo/screens/home/student_item.dart';
import 'package:provider/provider.dart';

class ListStudent extends StatefulWidget {
  const ListStudent({Key? key}) : super(key: key);

  @override
  _ListStudentState createState() => _ListStudentState();
}

class _ListStudentState extends State<ListStudent> {
  @override
  Widget build(BuildContext context) {
    final students = Provider.of<List<Student>>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            return StudentItem(student: students[index]);
          }),
    );
  }
}
