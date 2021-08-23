import 'package:flutter/material.dart';
import 'package:project_demo/screens/authenticate/register.dart';
import 'package:project_demo/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignUp = false;

  void toggleViewAuth() {
    setState(() {
      showSignUp = !showSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: showSignUp
            ? Register(toggleViewAuth: toggleViewAuth)
            : SignIn(toggleViewAuth: toggleViewAuth));
  }
}
