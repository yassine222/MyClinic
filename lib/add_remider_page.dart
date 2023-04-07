// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_adjacent_string_concatenation, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'controller/remider_controller.dart';
import 'input_field.dart';
import 'models/task.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  // ignore: prefer_final_fields
  final ReminderController _ReminderController = Get.put(ReminderController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _selectedRepeat = "None";
  List<String> repeatlist = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        title: Text("Add a Reminder"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              controller: _titleController,
              title: "Title",
              hint: "Enter a title",
            ),
            InputField(
              controller: _noteController,
              title: "Notes",
              hint: "Enter your notes",
            ),
            InputField(
              title: "Date",
              hint: DateFormat.yMd().format(_selectedDate),
              controller: null,
              widget: IconButton(
                onPressed: () {
                  _getDateFromUser();
                },
                icon: Icon(Icons.calendar_today_outlined),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    title: "Start Time",
                    hint: _startTime,
                    widget: IconButton(
                      icon: Icon(Icons.access_time_filled_rounded),
                      onPressed: () {
                        _getTimeFromUser(true);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // Expanded(
                //   child: InputField(
                //     title: "End Time",
                //     hint: _endTime,
                //     widget: IconButton(
                //       icon: Icon(Icons.access_time_filled_rounded),
                //       onPressed: () {
                //         _getTimeFromUser(false);
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
            InputField(
              title: "Repeat",
              hint: _selectedRepeat,
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
                    _selectedRepeat = newValue.toString();
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
            SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Color"),
                    SizedBox(
                      height: 8,
                    ),
                    Wrap(
                      children: List<Widget>.generate(3, (int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: index == 0
                                  ? Colors.red
                                  : index == 1
                                      ? Colors.amber
                                      : Colors.green,
                              child: _selectedColor == index
                                  ? Icon(
                                      Icons.done,
                                      size: 18,
                                      color: Colors.white,
                                    )
                                  : Container(),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _validateDate();
                  },
                  child: Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepPurple,
                    ),
                    child: Center(
                      child: Text(
                        "+ Add Task",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //add to DB
      _addRemindertoDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required !",
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.deepPurple,
          ),
          backgroundColor: Colors.white,
          colorText: Colors.blueGrey.shade800,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  _addRemindertoDB() async {
    int value = await _ReminderController.addReminder(
      Reminder(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print("My id is" + "$value");
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

  _getTimeFromUser(bool isStartTime) async {
    var pickedTime = await _showTimePicker();
    String formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("time canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
  }
}
