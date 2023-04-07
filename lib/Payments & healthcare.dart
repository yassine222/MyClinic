// ignore_for_file: prefer_const_constructors, duplicate_ignore, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';

class Payments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        title: Text("Payments & healthCash"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
          ),
          Center(
            child: Icon(Icons.dangerous_rounded,
                size: 200, color: Colors.indigo.shade800),
          ),
          // ignore: prefer_const_constructors
          Text(
            "Curently you don't have any favourite doc !",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
