// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Doctors extends StatefulWidget {
  @override
  State<Doctors> createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  String selectedRegion = "Show All";
  List<String> region = [
    "Show All",
    "Ariana",
    "Bizerte",
    "Tunis",
    "Sousse",
    "Sfax",
    "Monastir"
  ];
  final CollectionReference doctors =
      FirebaseFirestore.instance.collection('doctors');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        actions: [
          DropdownButton(
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
        ],
        backgroundColor: Colors.blueGrey.shade800,
        title: Text("My Doctors"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: StreamBuilder(
            stream: selectedRegion == "Show All"
                ? doctors.snapshots()
                : doctors
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
                        onTap: () {
                          print(documentSnapshot["id"]);
                        },
                        leading: CircleAvatar(
                            foregroundImage:
                                NetworkImage(documentSnapshot["image"])),
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
                        trailing: IconButton(
                          onPressed: () async {
                            final phoneNumber = documentSnapshot["phone"];

                            final Uri launchUri = Uri(
                              scheme: 'tel',
                              path: phoneNumber,
                            );
                            await launchUrl(launchUri);
                          },
                          icon: Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                        ),
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
    );
  }
}
