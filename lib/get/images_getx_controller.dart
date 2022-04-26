// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:flutter_api/api/controllers/images_api_controller.dart';
import 'package:get/get.dart';

import '../models/student_image.dart';

class ImagesGetxController extends GetxController {
  RxList<StudentImage> images = <StudentImage>[].obs;
  ImagesApiController apiController = ImagesApiController();

  static ImagesGetxController get to => Get.find();

  @override
  void onInit() {
    read();
    super.onInit();
  }

  Future<void> read() async {
    images.value = await apiController.images();
  }

  Future<bool> delete({required BuildContext context, required int id}) async {
    bool deleted = await apiController.deleteImage(context: context, id: id);
    if (deleted) {
      images.removeWhere((element) => element.id == id);
    }
    return deleted;
  }

  Future<void> upload(
      {required String filePath,
      required ImageUploadResponse imageUploadResponse}) async {
    apiController.uploadImage(
      filePath: filePath,
      imageUploadResponse: (
          // we overridden this method and then passed the values inside imageUploadResponse ..
          {required String message,
          required bool status,
          StudentImage? studentImage}) {
        if (status) {
          images.add(studentImage!);
        }
        imageUploadResponse(
            status: status, message: message, studentImage: studentImage);
      },
    );
  }
}
