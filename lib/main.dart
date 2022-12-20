import 'dart:io';

import 'package:contact/model/user.dart';
import 'package:contact/screens/addUser.dart';
import 'package:contact/screens/editUSer.dart';
import 'package:contact/screens/viewUser.dart';
import 'package:contact/services/user_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _searchController = TextEditingController();
  late List<User> _userList;
  final _userService = UserService();
  getAllUserDetails() async {
    _userList = <User>[];
    var users = await _userService.ReadUser();
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.phone = user['phone'];
        userModel.email = user['email'];
        userModel.image = user['image'];
        _userList.add(userModel);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  var result = await _userService.deleteUser(userId);
                  if (result != null) {
                    Navigator.pop(context);
                    getAllUserDetails();
                    _showSuccessSnackBar('Deleted Successfully');
                  }
                },
                child: const Text('Delete'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contact'),
          //search bar and input field
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Search'),
                          content: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                                hintText: 'Search by name, email or phone'),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  var search = _searchController.text;
                                  var result =
                                      await _userService.dataSearch(search);
                                  //set state and change data type
                                  //clear list
                                  _userList.clear();
                                  var users = result;
                                  users.forEach((user) {
                                    setState(() {
                                      var userModel = User();
                                      userModel.id = user['id'];
                                      userModel.name = user['name'];
                                      userModel.phone = user['phone'];
                                      userModel.email = user['email'];
                                      userModel.image = user['image'];
                                      _userList.add(userModel);
                                    });
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Search')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: ListView.builder(
            itemCount: _userList.length,
            itemBuilder: (context, index) {
              //return card
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewUser(
                                  user: _userList[index],
                                )));
                  },
                  //show image if available
                  leading: _userList[index].image != null
                      ? CircleAvatar(
                          backgroundImage:
                              FileImage(File(_userList[index].image!)),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                  title: Text(_userList[index].name ?? ''),
                  subtitle: Text(_userList[index].phone ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditUser(
                                          user: _userList[index],
                                        ))).then((data) {
                              if (data != null) {
                                getAllUserDetails();
                                _showSuccessSnackBar(
                                    'Contact Updated Successfully');
                              }
                            });
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue)),
                      IconButton(
                          onPressed: () {
                            _deleteFormDialog(context, _userList[index].id);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red)),
                    ],
                  ),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AddUser()))
                .then((data) {
              if (data != null) {
                getAllUserDetails();
                _showSuccessSnackBar('Contact Added Successfully');
              }
            });
          },
          child: const Icon(Icons.add),
        ));
  }
}
