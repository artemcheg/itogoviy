import 'package:flutter/material.dart';
import 'package:itogoviy/UserList.dart';
import 'package:itogoviy/mainScreen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const MainScreen(),
      '/users': (context) => const UsersList()
    },
  ));
}
