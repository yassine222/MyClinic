// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, constant_identifier_names, avoid_print, invalid_return_type_for_catch_error, unnecessary_null_comparison

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

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  DateTime? _birthDate;
  String? _sex = "Male";
  File? image;

  String? imageUrl;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 1);
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

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> updateProfile() async {
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

    // Call the user's CollectionReference to add a new user
    return await users.doc(user!.uid).update({
      'cin': _cinController.text,
      'name': _nameController.text,
      'surname': _surnameController.text,
      'email': user!.email,
      'image': imageUrl,
      'sex': _sex,
      'birthDate': DateFormat.yMd().format(_birthDate!),
    }).then((value) {
      print("profile updated");
    }).catchError((error) => print("Fialed to update profile: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

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
                    title: Text(
                      "Edit Profile",
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
                              foregroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl!)
                                  : NetworkImage("${data['image']}")),
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
                          hint: "${data['cin']}".isEmpty
                              ? "Enter your CIN Number"
                              : "${data['cin']}",
                          inputType: TextInputType.number,
                          controller: _cinController,
                          maxlength: 8,
                        ),
                        InputField(
                          // controller: _titleController,
                          title: "Name", controller: _nameController,
                          hint: "${data['cin']}".isEmpty
                              ? "Enter your name"
                              : "${data['name']}",
                        ),
                        InputField(
                          // controller: _titleController,
                          title: "Surname",
                          controller: _surnameController,
                          hint: "${data['surname']}".isEmpty
                              ? "Enter your surname"
                              : "${data['surname']}",
                        ),
                        InputField(
                          title: "Birth Date",
                          hint: "${data['birthDate']}".isEmpty
                              ? "Enter your birth date"
                              : "${data['birthDate']}",
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
                            updateProfile().then((value) => Get.to(Acceuill()));
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
                                "Update Profile",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  )),
            );
          }
          return SizedBox();
        });
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
