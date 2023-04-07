// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_print, invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testa/testbookings.dart';
import 'package:testa/appointment_page.dart';
import 'package:testa/doctors_page.dart';
import 'package:testa/edit_profile.dart';
import 'package:testa/login.dart';
import 'drawerclass.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Acceuill extends StatefulWidget {
  const Acceuill({super.key});

  @override
  State<Acceuill> createState() => _AcceuillState();
}

class _AcceuillState extends State<Acceuill> {
  final user = FirebaseAuth.instance.currentUser;
  bool? profileExist;
  final controller = PageController();
  final pages = List.generate(
      6,
      (index) => SizedBox(
            height: 280,
            child: Center(child: Image.asset('images/spread.jpg')),
          ));

  final colors = const [
    Colors.red,
    Colors.green,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.blue,
    Colors.amber,
  ];
  checkIfDocExists() async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(user!.uid).get();
      if (doc.exists == true) {
        setState(() {
          profileExist = true;
        });
      } else {
        setState(() {
          profileExist = false;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setRegion() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Call the user's CollectionReference to add a new user
    return await users.doc(user!.uid).update({
      'region': selectedRegion,
    }).then((value) async {
      print("Region is Set");
    }).catchError((error) => print("Failed to add user: $error"));
  }

  List<String> region = [
    "Ariana",
    "Bizerte",
    "Tunis",
    "Sousse",
    "Sfax",
    "Monastir"
  ];

  String selectedRegion = "Tunis";
  @override
  Widget build(BuildContext context) {
    checkIfDocExists();
    if (profileExist == false) {
      return SetProfile();
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(backgroundColor: Colors.black38, actions: <Widget>[
            // Expanded(child: const drawer()),
            // SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: 100,
                width: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pink.shade200),
                child: Row(children: [
                  Text(
                    '  Explore',
                    style: TextStyle(
                        color: Colors.black38, fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 5, bottom: 5),
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purpleAccent, // foreground
                      ),
                      onPressed: () {},
                      child: const Text(
                        'PLUS',
                        style: TextStyle(
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black38,
                              offset: Offset(-5.0, 5.0),
                            ),
                          ],
                          letterSpacing: 2,
                          fontSize: 10,
                        ),
                      ),
                      // icon: Icon(Icons.rectangle),
                    ),
                  ),
                ]),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Padding(
                padding: EdgeInsets.only(right: 10.0, top: 20),
                child: GestureDetector(
                  onTap: () async {
                    FirebaseAuth.instance.signOut();
                    Get.to(MyLogin());
                  },
                  child: Icon(
                    Icons.logout,
                    size: 30.0,
                    color: Colors.green.shade500,
                  ),
                )),
            // SizedBox(height: 10,),
          ]),
        ),
        drawer: const drawer(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.blue.shade900,
                ),
                Text(
                  selectedRegion,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w700),
                ),
                DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue.shade900,
                  ),
                  iconSize: 32,
                  elevation: 2,
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      selectedRegion = newValue.toString();
                      setRegion();
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
              ]),
            ),
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'images/Healthcare Apps Best Practices.jpg',
                    width: 380,
                    height: 150,
                  )),
            ),
            const SizedBox(height: 40),

            Column(
              children: [
                SizedBox(
                  height: 150,
                  child: PageView(
                    controller: controller,
                    children: [
                      Center(
                        child: Row(children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Get.to(AppointmentPage()),
                              child: ClipRRect(
                                // borderRadius: BorderRadius.circular(50),
                                child: Card(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 120,
                                        child: Image.asset(
                                          'images/doc.jpg',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text('Book '),
                                      Text('appointment')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () => Get.to(TestBookings()),
                              child: ClipRRect(
                                // borderRadius: BorderRadius.circular(25),
                                child: Card(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 120,
                                        child: Image.asset(
                                          'images/labtesting.jpeg',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text('Lab Tests'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Get.to(Doctors()),
                              child: ClipRRect(
                                // borderRadius: BorderRadius.circular(25),
                                child: Card(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 120,
                                        child: Image.asset(
                                          'images/Sanna chokri.jpg',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text('Doctors'),
                                      SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Center(
                        child: Row(children: [
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              // borderRadius: BorderRadius.circular(25),
                              child: Card(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 120,
                                      child: Image.asset(
                                        'images/Medecines.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Text('Medecines'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              // borderRadius: BorderRadius.circular(25),
                              child: Card(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 120,
                                      child: Image.asset(
                                        'images/insurance.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Text('Insurance'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Instant Video Consultaion for COVID-19 symptoms",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "connect with top medical experts, 24/7",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),

            Center(
              child: Column(children: [
                SizedBox(
                  height: 120,
                  child: PageView(
                    controller: controller,
                    children: [
                      Row(children: [
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CircleAvatar(
                            radius: 80,
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/loss of apetite.png',
                                  height: 80,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  'loss of taste',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CircleAvatar(
                            radius: 80,
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/headache.png',
                                  height: 80,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  'Headaches',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CircleAvatar(
                            radius: 80,
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/sneezing.png',
                                  height: 80,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  'Sneezing',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CircleAvatar(
                            radius: 80,
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/loss of smell.png',
                                  height: 80,
                                ),
                                Text(
                                  'loss of smell',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                      Row(children: [
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CircleAvatar(
                            radius: 80,
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/fever.png',
                                  height: 80,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  'Fever',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CircleAvatar(
                            radius: 80,
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/fatigue.png',
                                  height: 80,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  'Fatigue',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CircleAvatar(
                            radius: 80,
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/breathing def.png',
                                  height: 70,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  '  problems ',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'breathing',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CircleAvatar(
                            radius: 80,
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/sore throat.png',
                                  fit: BoxFit.fill,
                                  height: 80,
                                ),
                                Text(
                                  'Sore throat',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              width: 400,
              height: 400,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Corona spread status world wide :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: PageView.builder(
                              controller: controller,
                              // itemCount: pages.length,
                              itemBuilder: (_, index) {
                                return pages[index % pages.length];
                              },
                            ),
                          ),
                        ),

                        SmoothPageIndicator(
                          controller: controller,
                          count: pages.length,
                          effect: CustomizableEffect(
                            activeDotDecoration: DotDecoration(
                              width: 32,
                              height: 12,
                              color: Colors.indigo,
                              rotationAngle: 180,
                              verticalOffset: -10,
                              borderRadius: BorderRadius.circular(24),
                              // dotBorder: DotBorder(
                              //   padding: 2,
                              //   width: 2,
                              //   color: Colors.indigo,
                              // ),
                            ),
                            dotDecoration: DotDecoration(
                              width: 24,
                              height: 12,
                              color: Colors.black,
                              // dotBorder: DotBorder(
                              //   padding: 2,
                              //   width: 2,
                              //   color: Colors.grey,
                              // ),
                              // borderRadius: BorderRadius.only(
                              //     topLeft: Radius.circular(2),
                              //     topRight: Radius.circular(16),
                              //     bottomLeft: Radius.circular(16),
                              //     bottomRight: Radius.circular(2)),
                              borderRadius: BorderRadius.circular(16),
                              verticalOffset: 0,
                            ),
                            spacing: 6.0,
                            // activeColorOverride: (i) => colors[i],
                            inActiveColorOverride: (i) => colors[i],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 200,),
            // Center(
            //   child: Image.asset('images/insurance.jpg',
            //     width: 380,
            //     height: 150,),
            // ),
            //
            //       Padding(
            //         padding: EdgeInsets.all(5.0),
            //         child: Align(
            //           alignment: Alignment.centerLeft,
            //           child: Text(
            //             "Freezers And Ultra Deep Freezers",
            //             // style:  textFont,
            //           ),
            //         ),
            //       ),
          ]),
        ),
      );
    }
  }
}
