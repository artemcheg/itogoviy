import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itogoviy/drawer.dart';
import 'UserList.dart';

List<Task> parseTask(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Task>((json) => Task.fromJson(json)).toList();
}

Future<List<Task>> fetchTask(http.Client client, int index) async {
  final response = await client.get(
      Uri.parse("https://jsonplaceholder.typicode.com/todos?userId=$index"));
  return compute(parseTask, response.body);
}

class Task {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  Task(
      {required this.userId,
      required this.id,
      required this.title,
      required this.completed});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        userId: json["userId"] as int,
        id: json["id"] as int,
        title: json["title"] as String,
        completed: json["completed"] as bool);
  }
}

class UserTask extends StatelessWidget {
  const UserTask({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navDrawer(context),
      appBar: AppBar(
        title: const Text("Информация о пользователе"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          const SizedBox(height: 30,),
          const Text("Информация о пользователе:",style: TextStyle(fontSize: 25),),
          UserInfo(user: user),
          const SizedBox(height: 10,),
          const Text("Задачи:",style: TextStyle(fontSize: 25),),
          const SizedBox(height: 30,),
          FutureBuilder<List<Task>>(
              future: fetchTask(http.Client(), user.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InfoItem(task: snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ]),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem({Key? key, required this.task}) : super(key: key);
  final List<Task> task;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: task.length,
      itemBuilder: (context, index) {
        return Card(
          color:const Color(0xFFede0d4),
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Id задачи ${task[index].id}"),
                const SizedBox(
                  height: 10,
                ),
                CheckboxListTile(
                  value: task[index].completed,
                  onChanged: null,
                  title: Text(task[index].title),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFede0d4),border: Border.all(color:const Color(0xFFede0d4)),borderRadius: const BorderRadius.all(Radius.circular(20))),
      // color: const Color(0xFFede0d4),
      margin: const EdgeInsets.fromLTRB(4, 30, 4, 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text("Id пользователя: ${user.id}"),
          const SizedBox(height: 10,),
          Text("Имя: ${user.name}"),
          const SizedBox(height: 10,),
          Text("Имя пользователя: ${user.userName}"),
          const SizedBox(height: 10,),
          Text("Mail: ${user.email}"),
          const SizedBox(height: 20,),
          const Divider(height: 1,color: Colors.black,),
          const Text("Адрес:"),
          Column(
            children: [
              Text("Улица: ${user.address["street"]}"),
              Text("Квартира: ${user.address["suite"]}"),
              Text("Город: ${user.address["city"]}"),
              Text("Индекс: ${user.address["zipcode"]}"),
              const Divider(height: 1,color: Colors.black,),
              const SizedBox(height: 20,),
              const Divider(height: 1,color: Colors.black,),
              const Text("Координаты:"),

              Column(
                children: [
                  Text("Широта: ${user.address["geo"]["lat"]}"),

                  Text("Долгота: ${user.address["geo"]["lng"]}"),
                  const Divider(height: 1,color: Colors.black,),
                  const SizedBox(height: 20,),

                ],
              ),
              Text("Номер телефона: ${user.phone}"),
              const SizedBox(height: 10,),
              Text("Web-сайт: ${user.website}"),
              const SizedBox(height: 20,),
              const Divider(height: 1,color: Colors.black,),
              const Text("Компания:"),
              Column(
                children: [
                  Text("Название: ${user.company["name"]}"),
                  Text("Девиз: ${user.company["catchPhrase"]}"),
                  Text("Сильные стороны: ${user.company["bs"]}"),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
