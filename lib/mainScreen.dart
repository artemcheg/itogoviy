import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itogoviy/drawer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Screen();
  }
}

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class LoginData {
  String phone = "";
  String password = "";

  String defaultPhone = "+79781234567";
  String defaultPassword = "123456";
}

class _ScreenState extends State<Screen> {
  LoginData loginData = LoginData();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    const borderStyle = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlue, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20)));

    const errorBorderStyle = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20)));

    final phoneHolder = TextEditingController(text: "+7");
    final passwordHolder = TextEditingController();

    return Scaffold(
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       const DrawerHeader(
      //           decoration: BoxDecoration(color: Colors.blue),
      //           child: FlutterLogo()),
      //       ListTile(
      //         leading: const Icon(Icons.supervised_user_circle),
      //         title: const Text("Пользователи"),
      //         onTap: () {
      //           setState(() {
      //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //               content: const Text(
      //                 "Необходимо войти в личный кабинет",
      //                 style: TextStyle(color: Colors.black),
      //               ),
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(10.0),
      //               ),
      //               backgroundColor: const Color(0xFFede0d4),
      //               action: SnackBarAction(label: "Скрыть", onPressed: () { null; },
      //                 textColor: Colors.black,
      //               ),
      //             ));
      //           });
      //         },
      //       ),
      //       const Divider(),
      //       ListTile(
      //         leading: const Icon(Icons.logout),
      //         title: const Text("Выйти из аккаунта"),
      //         onTap: () {
      //           Navigator.pushNamed(context, "/");
      //         },
      //       )
      //     ],
      //   ),
      // ),
      // appBar: AppBar(
      //   title: const Text("Итоговый проект"),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Text(
                  "Авторизация",
                  style: TextStyle(fontSize: 25),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 25),
                          child: TextFormField(
                            controller: phoneHolder,
                            validator: (String? inValue) {
                              if (inValue != null && inValue.length < 12) {
                                return "Введите корректный логин";
                              } else if (inValue != loginData.defaultPhone) {
                                return "Такого пользователя нет!";
                              }
                              return null;
                            },
                            onSaved: (String? inValue) {
                              loginData.phone = inValue!;
                            },
                            maxLength: 12,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.phone),
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      phoneHolder.clear();
                                    }),
                                filled: true,
                                label: const Text("Введите номер телефона"),
                                errorBorder: errorBorderStyle,
                                focusedErrorBorder: errorBorderStyle,
                                enabledBorder: borderStyle,
                                focusedBorder: borderStyle),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                            controller: passwordHolder,
                            validator: (String? inValue) {
                              if (inValue != null && inValue.length < 6) {
                                return "Введите минимум 6 символов";
                              } else if (inValue != loginData.defaultPassword) {
                                return "Не верный пароль";
                              }
                              return null;
                            },
                            onSaved: (String? inValue) {
                              loginData.password = inValue!;
                            },
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.password_rounded),
                                filled: true,
                                label: const Text("Введите пароль"),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      passwordHolder.clear();
                                    },
                                    icon: const Icon(Icons.clear)),
                                errorBorder: errorBorderStyle,
                                focusedErrorBorder: errorBorderStyle,
                                enabledBorder: borderStyle,
                                focusedBorder: borderStyle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_globalKey.currentState?.validate() != null &&
                          _globalKey.currentState?.validate() == true) {
                        _globalKey.currentState?.save();
                      }
                      if (loginData.defaultPassword == loginData.password &&
                          loginData.defaultPhone == loginData.phone) {
                        Navigator.pushNamed(context, "/users");
                      }
                    },
                    child: const Text('Войти'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
