// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:flutter/material.dart";

import '../../api/controllers/student_api_controller.dart';
import '../../utils/helpers.dart';
import '../../widgets/code_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({Key? key, required this.email})
      : super(
            key:
                key); // we took the email from the forget_password_screen because we need it here.

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with Helpers {
  String? _code;

  late TextEditingController _passwordTextController;
  late TextEditingController _passwordConfirmationTextController;
  late TextEditingController _firstCodeTextController;
  late TextEditingController _secondCodeTextController;
  late TextEditingController _thirdCodeTextController;
  late TextEditingController _fourthCodeTextController;

  late FocusNode _firstFocusNode;
  late FocusNode _secondFocusNode;
  late FocusNode _thirdFocusNode;
  late FocusNode _fourthFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordTextController = TextEditingController();
    _passwordConfirmationTextController = TextEditingController();

    _firstCodeTextController = TextEditingController();
    _secondCodeTextController = TextEditingController();
    _thirdCodeTextController = TextEditingController();
    _fourthCodeTextController = TextEditingController();

    _firstFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
    _thirdFocusNode = FocusNode();
    _fourthFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordTextController.dispose();
    _passwordConfirmationTextController.dispose();

    _firstCodeTextController.dispose();
    _secondCodeTextController.dispose();
    _thirdCodeTextController.dispose();
    _fourthCodeTextController.dispose();

    _firstFocusNode.dispose();
    _secondFocusNode.dispose();
    _thirdFocusNode.dispose();
    _fourthFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Reset Password", style: TextStyle(color: Colors.black)),
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
            "Welcome Back ...",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            "Enter Code & New password",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: CodeTextField(
                  codeTextController: _firstCodeTextController,
                  focusNode: _firstFocusNode,
                  onChanged: (String value) {
                    if (value.isNotEmpty) _secondFocusNode.requestFocus();
                  },
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: CodeTextField(
                  codeTextController: _secondCodeTextController,
                  focusNode: _secondFocusNode,
                  onChanged: (String value) {
                    if (value.isNotEmpty) {
                      _thirdFocusNode.requestFocus();
                    } else {
                      _firstFocusNode.requestFocus();
                    }
                  },
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: CodeTextField(
                  codeTextController: _thirdCodeTextController,
                  focusNode: _thirdFocusNode,
                  onChanged: (String value) {
                    if (value.isNotEmpty) {
                      _fourthFocusNode.requestFocus();
                    } else {
                      _secondFocusNode.requestFocus();
                    }
                  },
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: CodeTextField(
                  codeTextController: _fourthCodeTextController,
                  focusNode: _fourthFocusNode,
                  onChanged: (String value) {
                    if (value.isEmpty) _thirdFocusNode.requestFocus();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: _passwordTextController,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "New Password",
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
          TextField(
            controller: _passwordConfirmationTextController,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Confirm New Password",
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
          ElevatedButton(
            onPressed: () async => performResetPassword(),
            child: Text("Reset Password", style: TextStyle(fontSize: 18)),
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

  Future<void> performResetPassword() async {
    if (checkData()) {
      await resetPassword();
    }
  }

  bool checkData() {
    // Single Responsibility method
    if (checkCode()) {
      if (checkPassword()) {
        // اللي رسالتها مخصصة خليها نستد
        return true;
      }
    } // else {}
    showSnackBar(
        // رسالة عامة
        context: context,
        message: "Enter All Required Data!",
        error: true);
    return false;
  }

  bool checkCode() {
    if (_firstCodeTextController.text.isNotEmpty &&
        _secondCodeTextController.text.isNotEmpty &&
        _thirdCodeTextController.text.isNotEmpty &&
        _fourthCodeTextController.text.isNotEmpty) {
      _code = _firstCodeTextController.text +
          _secondCodeTextController.text +
          _thirdCodeTextController.text +
          _fourthCodeTextController.text;
      return true;
    }
    showSnackBar(
        // رسالة عامة
        context: context,
        message: "Enter Sent Code!",
        error: true);
    return false;
  }

  bool checkPassword() {
    if (_passwordTextController.text.isNotEmpty &&
        _passwordConfirmationTextController.text.isNotEmpty) {
      if (_passwordTextController.text ==
          _passwordConfirmationTextController.text) {
        return true;
      }
      showSnackBar(
          // رسالة مخصصة
          context: context,
          message: "Password Confirmation Failed",
          error: true);
    }
    return false;
  }

  Future<void> resetPassword() async {
    bool status = await StudentApiController()
        // widget.email is to reach the email variable from the className above by its classNameState
        .resetPassword(
            context: context,
            email: widget.email,
            code: _code!,
            password: _passwordTextController.text);
    if (status) {
      Navigator.pop(context); //
    }
  }
}
