// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:flutter/material.dart';

class NotifPage extends StatelessWidget {
  final String? label;
  const NotifPage({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        title: Text(this.label.toString().split("|")[0]),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Center(
            child: Text(
              label.toString().split("|")[1],
              style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}
