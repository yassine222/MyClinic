// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, avoid_print, invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({super.key});

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  final user = FirebaseAuth.instance.currentUser;

  CollectionReference myAppointments =
      FirebaseFirestore.instance.collection('users');
  CollectionReference docAppointments =
      FirebaseFirestore.instance.collection('doctors');

  Future<void> cancelAppointment(String id) {
    return myAppointments
        .doc(user!.uid)
        .collection("myappointments")
        .doc(id)
        .delete()
        .then((value) {
      print("Apointments Canceled");
      Fluttertoast.showToast(msg: "Appointment Canceled");
    }).catchError((error) => print("Failed to delete user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        title: Text("My Appointments"),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: StreamBuilder(
        stream: myAppointments
            .doc(user!.uid)
            .collection("myappointments")
            .orderBy("date", descending: false)
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
                          foregroundImage: NetworkImage(
                            documentSnapshot["docImage"],
                          ),
                        ),
                        title: Text(
                          "Dr " + documentSnapshot["docName"],
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          documentSnapshot["docSpecialite"],
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            cancelAppointment(documentSnapshot.id);
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
                                documentSnapshot["docAdresse"],
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
        },
      ),
    );
  }
}
