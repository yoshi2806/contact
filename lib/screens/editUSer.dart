import 'package:contact/model/user.dart';
import 'package:flutter/material.dart';

import '../services/user_service.dart';

class EditUser extends StatefulWidget {
  final User user;
  const EditUser({super.key, required this.user});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneController = TextEditingController();
  bool _validateUser = false;
  bool _validatePhone = false;
  var _userService = UserService();

  @override
  void initState() {
    setState(() {
      _nameController.text = widget.user.name ?? '';
      _emailController.text = widget.user.email ?? '';
      _phoneController.text = widget.user.phone ?? '';
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contact'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Edit Contact',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter Name',
                      errorText:
                          _validateUser ? 'Value Can\'t Be Empty' : null),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Number',
                      hintText: 'Enter Number',
                      errorText:
                          _validatePhone ? 'Value Can\'t Be Empty' : null),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter Email',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          setState(() {
                            _nameController.text.isEmpty
                                ? _validateUser = true
                                : _validateUser = false;
                            _phoneController.text.isEmpty
                                ? _validatePhone = true
                                : _validatePhone = false;
                          });
                          if (_validateUser == false &&
                              _validatePhone == false) {
                            // print('Data Can Save');
                            var _user = User();
                            _user.id = widget.user.id;
                            _user.name = _nameController.text;
                            _user.phone = _phoneController.text;
                            _user.email = _emailController.text;
                            var result = await _userService.UpdateUser(_user);
                            Navigator.pop(context, result);
                          }
                        },
                        child: const Text('Update')),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red[400],
                        ),
                        onPressed: () {
                          _nameController.clear();
                          _phoneController.clear();
                          _emailController.clear();
                        },
                        child: const Text('Clear'))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
