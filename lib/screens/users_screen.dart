// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables

import "package:flutter/material.dart";
import 'package:flutter_api/api/controllers/student_api_controller.dart';
import 'package:flutter_api/api/controllers/users_api_controller.dart';
import 'package:flutter_api/utils/helpers.dart';

import '../models/user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> with Helpers {
  List<User> _users = <User>[];
  late Future<List<User>> _future;

  @override
  void initState() {
    super.initState();
    _future = UsersApiController().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Users", style: TextStyle(color: Colors.grey.shade800)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(onPressed: () async => logout() , icon: Icon(Icons.logout)),
          IconButton(onPressed: () => Navigator.pushNamed(context, "/images_screen"), icon: Icon(Icons.image)),
        ],
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: FutureBuilder<List<User>?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            _users = snapshot.data ?? []; // or snapshot.data!
            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                      "${_users[index].firstName} ${_users[index].lastName}"),
                  subtitle: Text(_users[index].email),
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              },
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.warning, size: 80),
                Center(
                  child: Text(
                    "NO DATA!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> logout() async {
    bool status = await StudentApiController().logout();
    if (status) {
      Navigator.pushReplacementNamed(context, "/login_screen");
    } else {
      showSnackBar(
          context: context, message: "Logout Failed, Try again", error: true);
    }
  }
}
