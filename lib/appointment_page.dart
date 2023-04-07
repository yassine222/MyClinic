// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:testa/input_field.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({
    super.key,
  });

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final user = FirebaseAuth.instance.currentUser;
  DateTime? _selectedDate;
  String? selectedDoc;
  String? docID;
  String? docAdresse;
  String? docImage;

//patient info
  String? pName;
  String? pSurname;
  String? pCin;
  String? pImage;
  String? pEmail;

  String _selectedSpecialite = "Show All";
  List<String> region = [
    "Show All",
    "Ariana",
    "Bizerte",
    "Tunis",
    "Sousse",
    "Sfax",
    "Monastir"
  ];
  String selectedRegion = "Tunis";
  List<String> specialite = [
    "Show All",
    "Family medicine",
    "Optician",
    "Pediatrics",
    "Ophthalmology",
    "Dermatology",
    "Radiology"
  ];

  final CollectionReference doctors =
      FirebaseFirestore.instance.collection('doctors');
  Future<void> getUserInfo() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        pCin = "${data['cin']}";
        pName = "${data['name']}";
        pSurname = "${data['surname']}";
        pEmail = "${data['email']}";
        pImage = "${data['image']}";
      });
    });
  }

  Future<void> addToDocAppointment() async {
    return await doctors.doc(docID).collection("appointment").add({
      'date': DateFormat.yMd().format(_selectedDate!),
      'pName': pName,
      'pSurname': pSurname,
      'pCin': pCin,
      'pEmail': pEmail,
      'pImage': pImage,
    }).then((value) async {
      print("Appointment added to the doctor");
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> bookAppointment() async {
    if (selectedDoc == null || docID == null || _selectedDate == null) {
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
    final user = FirebaseAuth.instance.currentUser;

    // Call the user's CollectionReference to add a new user
    return await users.doc(user!.uid).collection("myappointments").add({
      'date': DateFormat.yMd().format(_selectedDate!),
      'docID': docID,
      'docName': selectedDoc,
      'docSpecialite': _selectedSpecialite,
      'docAdresse': docAdresse,
      'docImage': docImage,
    }).then((value) async {
      print("Appointment booked");
      Fluttertoast.showToast(msg: "Appointment Booked ");
      addToDocAppointment();
    }).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        title: Text(
          "Make Appointment",
        ),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  title: "Choose a Specalist",
                  hint: _selectedSpecialite,
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    iconSize: 32,
                    elevation: 2,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSpecialite = newValue.toString();
                      });
                    },
                    items: specialite.map<DropdownMenuItem<String>>(
                      (String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      },
                    ).toList(),
                  ),
                ),
                Container(
                  height: 300,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: StreamBuilder(
                      stream: _selectedSpecialite == "Show All"
                          ? doctors.snapshots()
                          : doctors
                              .where("specialite",
                                  isEqualTo: _selectedSpecialite)
                              .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];
                              return Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      foregroundImage: NetworkImage(
                                          documentSnapshot["image"]),
                                    ),
                                    title: Text(
                                      "Dr " +
                                          documentSnapshot["name"] +
                                          " " +
                                          documentSnapshot["surname"],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      documentSnapshot["specialite"],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onTap: () {
                                      getUserInfo();
                                      print(pName);
                                      setState(() {
                                        docImage = documentSnapshot["image"];
                                        docAdresse =
                                            documentSnapshot["adresse"];
                                        _selectedSpecialite =
                                            documentSnapshot["specialite"];
                                        docID = documentSnapshot["id"];
                                        selectedDoc = documentSnapshot["name"] +
                                            " " +
                                            documentSnapshot["surname"];
                                      });
                                      Fluttertoast.showToast(
                                        msg: "you selected Dr " +
                                            documentSnapshot["name"] +
                                            " " +
                                            documentSnapshot["surname"],
                                      );
                                    },
                                  ));
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
                InputField(
                  title: "Date",
                  hint: _selectedDate != null
                      ? DateFormat.yMd().format(_selectedDate!)
                      : "Pick a date for your appointment",
                  controller: null,
                  widget: IconButton(
                    onPressed: () {
                      _getDateFromUser();
                    },
                    icon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      bookAppointment();
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
                          "Schedule Appointment",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
      print(DateFormat.yMd().format(pickerDate));
      print(pickerDate);
    } else {
      print("error date is null");
    }
  }
}
