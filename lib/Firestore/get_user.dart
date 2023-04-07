// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class GetUser extends StatelessWidget {
  final String docID;
  const GetUser({super.key, required this.docID});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(docID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('images/man id.jpg'),
            ),
            title: Text("${data["name"]} ${data["surname"]}"),
            subtitle: Text('${data["email"]}'),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
