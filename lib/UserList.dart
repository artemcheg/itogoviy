import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itogoviy/UserInfo.dart';
import 'package:itogoviy/drawer.dart';

List<User> parseUser(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}

Future<List<User>> fetchUser(http.Client client) async {
  final response =
  await client.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
  return compute(parseUser, response.body);
}

class UserItem extends StatelessWidget {
  const UserItem({Key? key, required this.user}) : super(key: key);
  final List<User> user;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: user.length,
      itemBuilder: (context, index) {
        return Card(
          color:const Color(0xFFede0d4),
          child: InkWell(
            splashColor: Colors.blue,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => UserTask(user: user[index])));
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text("Id: ${user[index].id}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Пользователь: ${user[index].userName}"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Email: ${user[index].email} "),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;

  final String userName;
  final Map<String, dynamic> address;
  final String phone;
  final String website;
  final Map<String, dynamic> company;

  User({required this.id,
    required this.name,
    required this.email,
    required this.userName,
    required this.address,
    required this.phone,
    required this.website,
    required this.company});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        userName: json['username'] as String,
        address: json['address'],
        phone: json['phone'] as String,
        website: json['website'] as String,
        company: json['company']);
  }
}

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late Future<List<User>> futureUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navDrawer(context),
        appBar: AppBar(
          title: const Text("Список пользователей"),
        ),
        body: Center(
          child: FutureBuilder<List<User>>(
            future: fetchUser(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return UserItem(user: snapshot.data!);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
