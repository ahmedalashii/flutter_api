// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_api/prefs/student_preferences_controller.dart';
import "package:http/http.dart" as http;
import '../../models/student.dart';
import '../../utils/helpers.dart';
import '../api_settings.dart'; // كاني لخصت كل المكتبة بكلمة http

class StudentApiController with Helpers {
  Future<bool> login({required String email, required String password}) async {
    var url = Uri.parse(ApiSettings.LOGIN); // transform the text into URI
    var response = await http.post(url, body: {
      "email": email,
      "password": password,
    });
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      Student student = Student.fromJson(jsonResponse["object"]);
      StudentPreferencesController().saveStudent(student: student);
      return true;
    } else if (response.statusCode == 200) {
      //
    } else {
      //
    }
    return false;
  }

  Future<bool> logout() async {
    var url = Uri.parse(ApiSettings.LOGOUT);
    var response = await http.get(url, headers: {
      // headers is for giving the authorization >> it means that the logout needs authorization
      HttpHeaders.authorizationHeader: StudentPreferencesController().token,
      HttpHeaders.acceptHeader: "application/json",
    });
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 401) {
      // 401 is when the token is expired
      await StudentPreferencesController().logout();
      return true;
    } // 500
    return false;
  }

  Future<bool> register(
      {required BuildContext context,
      required String fullName,
      required String email,
      required String password,
      required String gender}) async {
    var url = Uri.parse(ApiSettings.REGISTER);
    var response = await http.post(url, body: {
      "full_name": fullName,
      "email": email,
      "password": password,
      "gender": gender,
    });
    if (response.statusCode == 201) {
      // 201 >> Created
      showSnackBar(
          context: context,
          message: jsonDecode(response.body)['message']); // error is false
      return true;
    } else if (response.statusCode == 400) {
      showSnackBar(
          context: context,
          message: jsonDecode(response.body)['message'],
          error: true);
    } else {
      showSnackBar(
          context: context,
          message: "Something went wrong, please try again!",
          error: true);
    }
    return false;
  }

  Future<bool> forgetPassword({
    required BuildContext context,
    required String email,
  }) async {
    var url = Uri.parse(ApiSettings.FORGET_PASSWORD);
    var response = await http.post(url, body: {
      "email": email,
    });
    var jsonObject = jsonDecode(response.body);
    if (response.statusCode == 200) {
      showSnackBar(context: context, message: jsonObject["message"]);
      print("Code : ${jsonObject["code"]}"); // to know the code
      return true;
    } else if (response.statusCode == 400) {
      showSnackBar(
          context: context, message: jsonObject["message"], error: true);
    }else{
      showSnackBar(
          context: context, message: "Something went wrong, try again later!", error: true);
    }
    return false;
  }
  Future<bool> resetPassword({
    required BuildContext context,
    required String email,
    required String code,
    required String password, // or we can also take password_confirmation
  }) async {
    var url = Uri.parse(ApiSettings.RESET_PASSWORD);
    var response = await http.post(url, body: {
      "email": email,
      "code": code,
      "password": password,
      "password_confirmation": password,
    });
    var jsonObject = jsonDecode(response.body);
    if (response.statusCode == 200) {
      showSnackBar(context: context, message: jsonObject["message"]);
      return true;
    } else if (response.statusCode == 400) {
      showSnackBar(
          context: context, message: jsonObject["message"], error: true);
    }else{
      showSnackBar(
          context: context, message: "Something went wrong, try again later!", error: true);
    }
    return false;
  }
}
