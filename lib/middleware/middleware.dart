import 'package:flutter/material.dart';
import 'package:project_demo/models/user.dart';
import 'package:project_demo/screens/authenticate/authenticate.dart';
import 'package:project_demo/screens/home/home.dart';
import 'package:provider/provider.dart';

class Middleware extends StatelessWidget {
  const Middleware({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    // bool loading = Provider.of<bool>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
