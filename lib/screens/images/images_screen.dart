// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:flutter/material.dart";
import 'package:flutter_api/get/images_getx_controller.dart';
import 'package:get/get.dart';

import '../../api/api_settings.dart';
import '../../utils/helpers.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> with Helpers {
  ImagesGetxController controller = Get.put(ImagesGetxController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Images", style: TextStyle(color: Colors.grey.shade800)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
        actions: <Widget>[
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/upload_image_screen"),
              icon: Icon(Icons.upload)),
        ],
      ),
      body: GetX<ImagesGetxController>(
        builder: (ImagesGetxController controller) {
          if (controller.images.isNotEmpty) {
            return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: controller.images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          ApiSettings.IMAGES_URL +
                              controller.images[index].image,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 60,
                            color: Colors.black38,
                            alignment: AlignmentDirectional.centerEnd,
                            child: IconButton(
                              onPressed: () async => await deleteImage(
                                  id: controller.images[index].id),
                              icon: Icon(Icons.delete,
                                  color: Colors.red.shade900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.warning, size: 80),
                  Text(
                    "NO DATA!",
                    style: TextStyle(fontSize: 22, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> deleteImage({required int id}) async {
    bool isDeleted =
        await ImagesGetxController.to.delete(context: context, id: id);
    String message = (isDeleted) ? "Deleted Successfully" : "Deleted Failed!";
    showSnackBar(context: context, message: message, error: !isDeleted);
  }
}
