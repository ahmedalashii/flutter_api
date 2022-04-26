// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_api/prefs/student_preferences_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/student_image.dart';
import '../../utils/helpers.dart';
import '../api_settings.dart';
import "package:http/http.dart" as http;

// Typedef in Dart is used to create a user-defined identity (alias) for a function, and we can use that identity in place of the function in the program code. When we use typedef we can define the parameters of the function.
typedef ImageUploadResponse = void Function(
    {required bool status,
    StudentImage? studentImage,
    required String message});

class ImagesApiController with Helpers {
  Future<void> uploadImage(
      {required String filePath,
      required ImageUploadResponse imageUploadResponse}) async {
    var url = Uri.parse(ApiSettings.IMAGES.replaceFirst("/{id}", ""));
    var request = http.MultipartRequest("POST",
        url); // we used MultipartRequest because we want to upload a file (image).
    var file = await http.MultipartFile.fromPath("image", filePath);
    request.files.add(file);
    request.headers[HttpHeaders.authorizationHeader] =
        StudentPreferencesController().token;
    // request.fields["nameOfTheField"] = ""; // if there's another field
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((event) {
      // event is like the response.body below in images()
      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(event);
        // return StudentImage.fromJson(jsonResponse["data"]) ; // we can't return an image inside a method which returns nothing .. (listen method above) >> we have to use closure
        // the closure :
        imageUploadResponse(
          status: true,
          studentImage: StudentImage.fromJson(jsonResponse["object"]),
          message: jsonResponse["message"],
        );
      } else if (response.statusCode == 400) {
        var jsonResponse = jsonDecode(event);
        imageUploadResponse(
          status: false,
          studentImage: StudentImage.fromJson(jsonResponse["object"]),
          message: jsonResponse["message"],
        );
      } else {
        imageUploadResponse(
          status: false,
          message: "Something went wrong. Please try again!",
        );
      }
    });
  }

  Future<List<StudentImage>> images() async {
    var url = Uri.parse(ApiSettings.IMAGES.replaceFirst("{id}", ""));
    var response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: StudentPreferencesController().token,
    });
    if (response.statusCode == 200) {
      var dataJsonArray = jsonDecode(response.body)["data"] as List;
      return dataJsonArray
          .map((element) => StudentImage.fromJson(element))
          .toList();
    }
    return [];
  }

  Future<bool> deleteImage(
      {required BuildContext context, required int id}) async {
    var url = Uri.parse(ApiSettings.IMAGES.replaceFirst("{id}", id.toString()));
    var response = await http.delete(url, headers: {
      HttpHeaders.authorizationHeader: StudentPreferencesController().token,
    });
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response
          .body); // this shouldn't be outside the if condition because if the token expired then we need to refresh it again.
      showSnackBar(
          context: context, message: jsonResponse["message"], error: false);
      return true;
    } else {
      // 500
      var jsonResponse = jsonDecode(response.body);
      showSnackBar(
          context: context, message: jsonResponse["message"], error: true);
    }
    return false;
  }
}
