// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors, invalid_return_type_for_catch_error, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'input_field.dart';

class TestBookings extends StatefulWidget {
  @override
  State<TestBookings> createState() => _TestBookingsState();
}

class _TestBookingsState extends State<TestBookings> {
  final user = FirebaseAuth.instance.currentUser;
  String selectedRegion = "Show All";
  String? selectedLab;
  String? labLogo;
  String? labID;
  List<String> region = [
    "Show All",
    "Ariana",
    "Bizerte",
    "Tunis",
    "Sousse",
    "Sfax",
    "Monastir"
  ];
  List<String> repeatlist = ["Urine test", "Blood test", "Tumor markers"];
  String _selectetestType = "Urine test";
  DateTime? _selectedDate;
  String? labName;
  String? labAdresse;

  String? pName;
  String? pSurname;
  String? pCin;
  String? pImage;
  String? pEmail;
  final CollectionReference testLabs =
      FirebaseFirestore.instance.collection('testlabs');

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

  Future<void> addToLabTest() async {
    return await testLabs.doc(labID).collection("TestAppoinments").add({
      'date': DateFormat.yMd().format(_selectedDate!),
      'pName': pName,
      'pSurname': pSurname,
      'pCin': pCin,
      'pEmail': pEmail,
      'pImage': pImage,
      'testType': _selectetestType,
    }).then((value) async {
      print("Appointment added to the doctor");
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> bookTest() async {
    if (_selectedDate == null || selectedLab == null) {
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
    return await users.doc(user!.uid).collection("mytests").add({
      'date': DateFormat.yMd().format(_selectedDate!),
      'labID': selectedLab,
      'labname': labName,
      'testType': _selectetestType,
      'adresse': labAdresse,
      'labLogo': labLogo,
    }).then((value) async {
      print("Test booked");
      addToLabTest();
      Fluttertoast.showToast(msg: "Test Booked ");
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
        backgroundColor: Colors.blueGrey.shade800,
        title: Text("Test Bookings"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              title: "Test Type",
              hint: _selectetestType,
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
                    _selectetestType = newValue.toString();
                  });
                },
                items: repeatlist.map<DropdownMenuItem<String>>(
                  (String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  },
                ).toList(),
              ),
            ),
            InputField(
              title: "Select Region",
              hint: selectedRegion,
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
                    selectedRegion = newValue.toString();
                  });
                },
                items: region.map<DropdownMenuItem<String>>(
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
              padding: EdgeInsets.only(top: 20, right: 20),
              child: Text(
                "Choose a Test Lab",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              height: 300,
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: StreamBuilder(
                  stream: selectedRegion == "Show All"
                      ? testLabs.snapshots()
                      : testLabs
                          .where("region", isEqualTo: selectedRegion)
                          .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                  foregroundImage:
                                      NetworkImage(documentSnapshot["logo"]),
                                ),
                                title: Text(
                                  "Test Lab " + documentSnapshot["name"],
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  documentSnapshot["adresse"],
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  setState(() {
                                    labLogo = documentSnapshot["logo"];
                                    labAdresse = documentSnapshot["adresse"];
                                    selectedLab = documentSnapshot.id;
                                    labName = documentSnapshot["name"];
                                    labID = documentSnapshot.id;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "you selected " +
                                          documentSnapshot["name"] +
                                          " test lab");
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
                  : "choose a date for your test",
              controller: null,
              widget: IconButton(
                onPressed: () {
                  _getDateFromUser();
                },
                icon: Icon(Icons.calendar_today_outlined),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    bookTest();
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
                        "Schedule Test",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
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
    } else {
      print("error date is null");
    }
  }
}
