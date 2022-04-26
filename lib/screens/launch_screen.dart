// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import 'package:flutter_api/prefs/student_preferences_controller.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      String routeName = StudentPreferencesController().loggedIn
          ? "/users_screen"
          : "/login_screen";
      Navigator.pushReplacementNamed(context, routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("API APP")),
    );
  }
}
