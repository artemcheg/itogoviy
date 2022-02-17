import 'package:flutter/material.dart';

Widget navDrawer(context) => Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: FlutterLogo()),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle),
            title: const Text("Пользователи"),
            onTap: () {
              Navigator.pushNamed(context, "/users");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Выйти из аккаунта"),
            onTap: () {
              Navigator.pushNamed(context, "/");
            },
          )
        ],
      ),
    );
