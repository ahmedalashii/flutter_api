import 'dart:convert';
import "package:http/http.dart" as http;
import '../../models/base_response.dart';
import '../../models/user.dart';
import '../api_settings.dart'; // كاني لخصت كل المكتبة بكلمة http

class UsersApiController {
  Future<List<User>> getUsers() async {
    var url = Uri.parse(ApiSettings.USERS); // transform the text into URI
    var response = await http.get(url);

    if (response.statusCode == 200) {
      BaseResponse<User> baseResponse = BaseResponse<User>.fromJson(jsonDecode(response.body)); // jsonDecode transfer from string into map
      return baseResponse.data!;
    } else if (response.statusCode == 400) {
    } else {

    }
    return [];
  }
}
