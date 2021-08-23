class Student {
  String studentAvatar;
  String studentName;
  String studentEmail;
  String studentId;
  double studentGPA;
  String? id;

  Student({
    required this.studentAvatar,
    required this.studentName,
    required this.studentEmail,
    required this.studentId,
    required this.studentGPA,
    this.id,
  });
}
