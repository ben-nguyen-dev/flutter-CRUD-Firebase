import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_demo/models/student.dart';
import 'package:project_demo/models/user.dart';
import 'package:project_demo/services/database.dart';
import 'package:project_demo/shareds/button.dart';
import 'package:provider/provider.dart';

class CreateStudentWidget extends StatefulWidget {
  final Student? studentEdit;
  const CreateStudentWidget({Key? key, this.studentEdit}) : super(key: key);

  @override
  _CreateStudentWidgetState createState() => _CreateStudentWidgetState();
}

class _CreateStudentWidgetState extends State<CreateStudentWidget> {
  late String studentEmail = "";
  late String studentName = "", studentId = "";
  late double studentGPA = 0;
  late String studentAvatar = "";

  late XFile? image;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.studentEdit == null) {
      //  create
    } else {
      //  edit
      studentEmail = widget.studentEdit!.studentEmail;
      studentName = widget.studentEdit!.studentName;
      studentId = widget.studentEdit!.studentId;
      studentGPA = widget.studentEdit!.studentGPA;
      studentAvatar = widget.studentEdit!.studentAvatar;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final DatabaseService _databaseService = DatabaseService(uid: user!.uid);

    selectImage(String typeSelectImage) async {
      if (typeSelectImage == "camera") {
        image = await ImagePicker().pickImage(source: ImageSource.camera);
      } else if (typeSelectImage == "file") {
        image = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        return;
      }

      String filePath = image!.path;
      String fileName = image!.path.split("/").last;

      // close dialog
      Navigator.pop(context);

      // upload file
      String downloadURL =
          await DatabaseService().uploadImageToFirebase(filePath, fileName);

      // print(image);
      if (downloadURL.isNotEmpty) {
        setState(() {
          studentAvatar = downloadURL;
        });
      }
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              studentAvatar.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(studentAvatar),
                                      radius: 50.0,
                                    )
                                  : const Text("No image choose"),
                              OutlinedButton(
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SimpleDialog(
                                    title: const Text(
                                        'Choose from camera or file'),
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              selectImage("camera");
                                            },
                                            child: const Image(
                                              image: AssetImage(
                                                  'images/icon-camera.png'),
                                              height: 60.0,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              selectImage("file");
                                            },
                                            child: const Image(
                                              image: AssetImage(
                                                  'images/icon-file.png'),
                                              height: 60.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                child: Text("Choose files"),
                              ),
                            ],
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Avatar",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 40.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  initialValue: studentName,
                  decoration: const InputDecoration(
                      labelText: "Name",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0))),
                  onChanged: (String value) {
                    setState(() {
                      studentName = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  initialValue: studentId,
                  decoration: const InputDecoration(
                      labelText: "ID",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0))),
                  onChanged: (String value) {
                    setState(() {
                      studentId = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  initialValue: studentEmail,
                  decoration: const InputDecoration(
                      labelText: "Email",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0))),
                  onChanged: (String value) {
                    studentEmail = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  initialValue: studentGPA == 0 ? "" : studentGPA.toString(),
                  decoration: const InputDecoration(
                      labelText: "GPA",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0))),
                  onChanged: (value) {
                    setState(() {
                      studentGPA = double.parse(value);
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonGradient(
                      label: widget.studentEdit == null ? "Add" : "Edit",
                      onPressed: () async {
                        if (widget.studentEdit == null) {
                          dynamic result = await _databaseService.addNewStudent(
                            studentName,
                            studentId,
                            studentEmail,
                            studentGPA,
                            studentAvatar,
                          );
                          if (result) {
                            Navigator.pop(context);
                          }
                        } else {
                          dynamic result = await _databaseService.updateStudent(
                            studentName,
                            studentId,
                            studentEmail,
                            studentGPA,
                            studentAvatar,
                            widget.studentEdit!.id,
                          );
                          if (result) {
                            Navigator.pop(context);
                          }
                        }
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
