// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_api/prefs/student_preferences_controller.dart';
import 'package:flutter_api/screens/auth/forget_password_screen.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/images/images_screen.dart';
import 'screens/images/upload_image_screen.dart';
import 'screens/launch_screen.dart';
import 'screens/users_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await StudentPreferencesController().initSharedPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/launch_screen",
      routes: {
        "/launch_screen": (context) => LaunchScreen(),
        "/users_screen": (context) => UsersScreen(),
        "/categories_screen": (context) => CategoriesScreen(),
        "/login_screen": (context) => LoginScreen(),
        "/register_screen": (context) => RegisterScreen(),
        "/forget_password_screen": (context) => ForgetPasswordScreen(),
        // "/reset_password_screen": (context) => ResetPasswordScreen(),
        "/images_screen": (context) => ImagesScreen(),
        "/upload_image_screen": (context) => UploadImageScreen(),
      },
    );
  }
}
