import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saleel/homepage.dart';

class AddStud extends StatefulWidget {
  const AddStud({super.key});

  @override
  State<AddStud> createState() => _AddStudState();
}

class _AddStudState extends State<AddStud> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  final formkey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var ageController = TextEditingController();
  void addUser() {
    String name = nameController.text;
    String age = ageController.text;

    FirebaseFirestore.instance
        .collection('Students')
        .add({'name': name, 'age': age})
        .then((value) => print('added successfully'))
        .catchError((error) => print('Failed to add user: $error'));

    nameController.clear();
    ageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: ((context) => const Home())));
        },
        backgroundColor: Colors.indigo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(
          Icons.people,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Center(
                    child: Text(
                  "Enter User Details!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                )),
                const SizedBox(
                  height: 40,
                ),
                CircleAvatar(
                  radius: 72,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      radius: 70,
                      backgroundColor: Colors.indigo,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text("Choose an option"),
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: const Text("Gallery"),
                                            onTap: () {
                                              _pickImage(ImageSource.gallery);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: const Text("Camera"),
                                            onTap: () {
                                              _pickImage(ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                          )
                                        ]));
                              });
                        },
                        child: Container(
                            height: 40,
                            child: const Image(
                              image: AssetImage(
                                "images/imgadd.png",
                              ),
                              color: Colors.white,
                            )),
                      )),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    if (value.length < 3) {
                      return 'Name must be at least 3 characters long';
                    }
                    if (value.length > 20) {
                      return 'Name can be at most 20 characters long';
                    }
                    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return 'Name cannot contain special characters';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Name',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Age must be a number';
                    }
                    int? age = int.tryParse(value);
                    if (age == null) {
                      return 'Invalid age';
                    }
                    if (age < 5) {
                      return 'Age must be greater than 5';
                    }
                    return null;
                  },
                  controller: ageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Age',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      addUser();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: ((context) => const Home())));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width / 1.4, 50),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style:
                        (TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
