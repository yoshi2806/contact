import 'dart:io';
import 'package:contact/model/user.dart';
import 'package:contact/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneController = TextEditingController();
  bool _validateUser = false;
  bool _validatePhone = false;
  var _userService = UserService();
  //image picker
  final picker = ImagePicker();
  XFile? image;
  //get image from gallery function
  void getImage() {
    picker.pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        image = value;
      });
    });
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
                  'Add New Contact',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                image == null
                    ? const CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        //show xfile image
                        backgroundImage: FileImage(File(image!.path))
                      ),
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.add_a_photo),
                  onPressed: () {
                    //use image picker
                    getImage();
                  },
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
                            _user.name = _nameController.text;
                            _user.phone = _phoneController.text;
                            _user.email = _emailController.text;
                            _user.image = image!.path;
                            print(_user.image);
                            var result = await _userService.SaveUser(_user);
                            Navigator.pop(context, result);
                          }
                        },
                        child: const Text('Save')),
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
