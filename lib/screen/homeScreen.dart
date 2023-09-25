import 'dart:math';

import 'package:flutter/material.dart';
import 'package:token_user/model/user.dart';
import 'package:token_user/shareManager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  List<User> users = [
    User(
      name: "yasin",
      token: "y4cn",
    ),
    User(
      name: "yasin_m_y",
      token: "instagram",
    ),
  ];

  User? user;

  @override
  void initState() {
    super.initState();
    testFunction();
  }

  //TODO Test Function Add User
  Future<void> testFunction() async {
    for (var element in users) {
      await ShareManager.SetStringLst(element.token);
    }
  }

  Future<void> itemUsers() async {
    //TODO Request Item User
    var singleToken = await ShareManager.getSingleString();

    //TODO اگه توکن منصر به فرد باشه یک آیتم برمیگردونه
    List<User> usersSelected =
        users.where((e) => e.token == singleToken).toList();

    user = usersSelected.first;
    setState(() {});
  }

  Future<List<String>> changeUser() async {
    List<String> userName = [];

    //TODO Request for users
    var lstitems = await ShareManager.getStringLst();

    for (var element in lstitems) {
      userName.add(element);
    }
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () async {
            var listUsers = await changeUser();

            if (listUsers.isNotEmpty) {
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: listUsers
                          .map<Widget>(
                            (e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () async {
                                  await ShareManager.SetSingleString(e);
                                  //TODO inja item ro ham seda mizanim
                                  await itemUsers();
                                  Navigator.pop(context);
                                },
                                child: Text(e),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              );
            }
          },
          child: const Text("Click here For Switch Profile"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO Create User
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _textEditingController,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            var randomToken = generateRandomString(10);
                            users.add(User(
                                name: _textEditingController.text.trim(),
                                token: randomToken));
                            ShareManager.SetStringLst(users.last.token);
                            Navigator.pop(context);
                          },
                          child: const Text("Add User"),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Center(
        child: Text(
          user == null ? "Null" : user!.name,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

//TODO Random String
String generateRandomString(int length) {
  const String characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  String result = '';

  for (int i = 0; i < length; i++) {
    int randomIndex = random.nextInt(characters.length);
    result += characters[randomIndex];
  }

  return result;
}
