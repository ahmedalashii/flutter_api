// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

import 'package:flutter_api/models/user.dart';

class BaseResponse<T> {
  late bool? status;
  late String? message;
  late List<T>? data;

  BaseResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      if (T == User) {
        data = <T>[];
        json['data'].forEach((v) {
          data!.add(User.fromJson(v) as T);
        });
      }
      // for(Map<String,dynamic> userJsonObject in json['data']){ // another representation for the method above.
      //     data!.add(User.fromJson(v));
      // }
    }
  }
}
