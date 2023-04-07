// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, constant_identifier_names, avoid_print, invalid_return_type_for_catch_error

import 'dart:io';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:testa/Acceuille.dart';

import 'input_field.dart';
import 'login.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({super.key});

  @override
  State<SetProfile> createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  DateTime? _birthDate;
  String? _sex = "Male";
  File? image;
  String? imageUrl;

  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 5);

      if (image == null) return;
      final imageTemp = File(image.path);
      Reference ref = FirebaseStorage.instance.ref().child(user!.uid);
      await ref.putFile(imageTemp);
      ref.getDownloadURL().then((value) {
        setState(() {
          imageUrl = value;
        });
        print(value);
      });

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> addUser() async {
    if (_cinController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _surnameController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required !",
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.deepPurple,
          ),
          backgroundColor: Colors.white,
          colorText: Colors.blueGrey.shade800,
          snackPosition: SnackPosition.BOTTOM);
    }
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Call the user's CollectionReference to add a new user
    return await users.doc(user!.uid).set({
      'cin': _cinController.text,
      'name': _nameController.text,
      'surname': _surnameController.text,
      'image': imageUrl,
      'email': user!.email,
      'sex': _sex,
      'birthDate': DateFormat.yMd().format(_birthDate!),
    }).then((value) async {
      print("profile is Set");
      Get.to(Acceuill());
    }).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.blueGrey.shade800,
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Get.to(MyLogin());
                  },
                  icon: Icon(Icons.arrow_back_ios_new))
            ],
            title: Text(
              "Set Profile",
            ),
            backgroundColor: Colors.blueGrey.shade800,
          ),
          body: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    foregroundImage: image != null
                        ? FileImage(image!)
                        : NetworkImage(
                                "https://cdn4.iconfinder.com/data/icons/evil-icons-user-interface/64/avatar-512.png")
                            as ImageProvider,
                  ),
                ),
                TextButton.icon(
                  onPressed: (() => pickImage()),
                  icon: Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Select Photo",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                InputField(
                  // controller: _titleController,
                  title: "CIN",
                  hint: "Enter your CIN number",
                  inputType: TextInputType.number,
                  controller: _cinController,
                  maxlength: 8,
                ),
                InputField(
                  // controller: _titleController,
                  title: "Name", controller: _nameController,
                  hint: "Enter your name",
                ),
                InputField(
                  // controller: _titleController,
                  title: "Surname",
                  controller: _surnameController,
                  hint: "Enter your Surname",
                ),
                InputField(
                  title: "Birth Date",
                  hint: _birthDate != null
                      ? DateFormat.yMd().format(_birthDate!)
                      : "Enter your birth date",
                  widget: IconButton(
                    onPressed: () {
                      _getDateFromUser();
                    },
                    icon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Male'),
                        leading: Radio<String>(
                          value: "Male",
                          groupValue: _sex,
                          onChanged: (String? value) {
                            setState(() {
                              _sex = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Female'),
                        leading: Radio<String>(
                          value: "Female",
                          groupValue: _sex,
                          onChanged: (String? value) {
                            setState(() {
                              _sex = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    addUser();
                    // print(_cinController.text.toString());
                    // print(_nameController.text.toString());
                    // print(_surnameController.text.toString());
                    // print(DateFormat.yMd().format(_birthDate!));
                    // print(_sex);
                    // print(user!.email);
                  },
                  child: Container(
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepPurple,
                    ),
                    child: Center(
                      child: Text(
                        "Set Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          )),
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1910),
      lastDate: DateTime(2030),
    );
    if (pickerDate != null) {
      setState(() {
        _birthDate = pickerDate;
      });
    } else {
      print("error date is null");
    }
  }
}


