import 'dart:convert';
import "package:http/http.dart" as http;
import '../../models/category.dart';
import '../api_settings.dart'; // كاني لخصت كل المكتبة بكلمة http

class CategoriesApiController {
  Future<List<Category>> getCategories() async {
    var url = Uri.parse(ApiSettings.CATEGORIES); // transform the text into URI
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var jsonArray = jsonResponse["data"] as List;
      return jsonArray
          .map((jsonObject) => Category.fromJson(jsonObject))
          .toList();
      // Another way of doing that line above:
      // List<Category> categories = [];
      // for(Map<String,dynamic> jsonObject in jsonArray){
      //   Category category = Category.fromJson(jsonObject);
      //   categories.add(category);
      // }
      // return categories;
    } else if (response.statusCode == 400) {
    } else {}
    return [];
  }
}
