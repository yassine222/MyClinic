// ignore_for_file: prefer_const_constructors, invalid_return_type_for_catch_error, avoid_print, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyTests extends StatefulWidget {
  @override
  State<MyTests> createState() => _MyTestsState();
}

class _MyTestsState extends State<MyTests> {
  final user = FirebaseAuth.instance.currentUser;

  CollectionReference myAppointments =
      FirebaseFirestore.instance.collection('users');

  Future<void> cancelTest(String id) {
    return myAppointments
        .doc(user!.uid)
        .collection("mytests")
        .doc(id)
        .delete()
        .then((value) {
      print("Test Appointment Canceled");
      Fluttertoast.showToast(msg: "Test Appointment Canceled");
    }).catchError((error) => print("Failed to delete user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        title: Text("My Tests"),
      ),
      body: Column(
        children: [
          Container(
            height: 500,
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: StreamBuilder(
                stream: myAppointments
                    .doc(user!.uid)
                    .collection("mytests")
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
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {},
                                leading: CircleAvatar(
                                  foregroundImage:
                                      NetworkImage(documentSnapshot["labLogo"]),
                                ),
                                title: Text(
                                  documentSnapshot["labname"],
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  documentSnapshot["testType"],
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    cancelTest(documentSnapshot.id);
                                  },
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              ListTile(
                                onTap: () {},
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        documentSnapshot["adresse"],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      documentSnapshot["date"],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.update,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
