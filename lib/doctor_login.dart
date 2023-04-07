// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';

class healthstaff extends StatefulWidget {
  const healthstaff({Key? key}) : super(key: key);

  @override
  State<healthstaff> createState() => _healthstaffState();
}

class _healthstaffState extends State<healthstaff> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blue.shade900,
          Colors.blue.shade300,
          Colors.purple.shade600,
        ],
      )),
      child: Row(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 300,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(500.0),
                      child: Image.asset(
                        'images/docc.jpg',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              const Text('Dr',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      color: Colors.black))
            ],
          ),
        ],
      ),
    );
  }
}
