// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import "package:flutter/material.dart";

import '../../api/controllers/student_api_controller.dart';
import '../../utils/helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  late TextEditingController _fullNameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  String _gender = "M";

  @override
  void initState() {
    super.initState();
    _fullNameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Text(
            "Create an account ...",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            "Enter below data",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _fullNameTextController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Full Name",
              prefixIcon: Icon(Icons.person),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _emailTextController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.email),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _passwordTextController,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Icons.lock),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Expanded(
              // أي ليست تايل جوات رُو لازم احجمها
              child: RadioListTile<String?>(
                title: Text("Male"),
                value: "M",
                groupValue: _gender,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _gender = value;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String?>(
                title: Text("Female"),
                value: "F",
                groupValue: _gender,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _gender = value;
                    });
                  }
                },
              ),
            ),
          ]),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => performRegister(),
            child: Text("Login"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(0, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performRegister() async {
    if (checkData()) {
      await register();
    }
  }

  bool checkData() {
    // Single Responsibility method
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty &&
        _fullNameTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
        context: context, message: "Enter Required Data!", error: true);
    return false;
  }

  Future<void> register() async {
    bool status = await StudentApiController().register(
        context: context,
        email: _emailTextController.text,
        fullName: _fullNameTextController.text,
        password: _passwordTextController.text,
        gender: _gender);
    if (status) {
      Navigator.pushReplacementNamed(context, "/login_screen");
    } else {
      showSnackBar(
          context: context, message: "Register failed Try Again!", error: true);
    }
  }
}
