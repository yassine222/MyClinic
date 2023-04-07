// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, non_constant_identifier_names, file_names, avoid_print

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:testa/add_remider_page.dart';
import 'package:testa/controller/remider_controller.dart';
import 'package:testa/models/task.dart';
import 'package:testa/notification_service.dart';
import 'package:testa/widgets/task_tile.dart';

class ReminderList extends StatefulWidget {
  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  final ReminderController _ReminderController = Get.put(ReminderController());

  @override
  void initState() {
    _ReminderController.getReminders();
    super.initState();

    NotifyerHelper().initializeNotification();
    NotifyerHelper().requestIOSPermissions();
  }

  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        title: Text("Reminders"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "today",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    await Get.to(AddReminder());
                    _ReminderController.getReminders();
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: Center(
                      child: Text(
                        "+ Add Reminder",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.amber,
              selectedTextColor: Colors.white,
              dateTextStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
              onDateChange: (selectedDate) {
                setState(() {
                  _selectedDate = selectedDate;
                });
                print(selectedDate);
                print(_ReminderController.reminderList.length);
              },
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Expanded(
            child: Obx(
              () {
                return ListView.builder(
                  itemCount: _ReminderController.reminderList.length,
                  itemBuilder: ((_, index) {
                    Reminder reminder = _ReminderController.reminderList[index];
                    if (reminder.repeat == "Daily") {
                      DateTime date =
                          DateFormat.jm().parse(reminder.startTime.toString());
                      var myTime = DateFormat("HH:mm").format(date);
                      NotifyerHelper().scheduledNotification(
                        int.parse(myTime.toString().split(":")[0]),
                        int.parse(myTime.toString().split(":")[1]),
                        reminder,
                      );

                      return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                            child: FadeInAnimation(
                                child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showBottomSheet(context, reminder);
                                  },
                                  child: TaskTile(reminder),
                                )
                              ],
                            )),
                          ));
                    }
                    if (reminder.date ==
                        DateFormat.yMd().format(_selectedDate)) {
                      DateTime date =
                          DateFormat.jm().parse(reminder.startTime.toString());
                      var myTime = DateFormat("HH:mm").format(date);
                      NotifyerHelper().scheduledNotification(
                        int.parse(myTime.toString().split(":")[0]),
                        int.parse(myTime.toString().split(":")[1]),
                        reminder,
                      );
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                            child: FadeInAnimation(
                                child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showBottomSheet(context, reminder);
                                  },
                                  child: TaskTile(reminder),
                                )
                              ],
                            )),
                          ));
                    } else {
                      DateTime date =
                          DateFormat.jm().parse(reminder.startTime.toString());
                      var myTime = DateFormat("HH:mm").format(date);
                      NotifyerHelper().scheduledNotification(
                        int.parse(myTime.toString().split(":")[0]),
                        int.parse(myTime.toString().split(":")[1]),
                        reminder,
                      );

                      return Container();
                    }
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _showBottomSheet(BuildContext context, Reminder reminder) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: reminder.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          reminder.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Reminder Done",
                  onTap: () {
                    _ReminderController.markReminderCompleted(reminder.id!);
                    Get.back();
                  },
                  color: Colors.blue,
                  context: context),
          _bottomSheetButton(
              label: "Delete Reminder",
              onTap: () {
                _ReminderController.delete(reminder);

                Get.back();
              },
              color: Colors.red,
              context: context),
          SizedBox(
            height: 5,
          ),
          _bottomSheetButton(
              isClose: true,
              label: "Close",
              onTap: () {
                Get.back();
              },
              color: Colors.white,
              context: context),
        ],
      ),
    ));
  }

  _bottomSheetButton({
    required String label,
    required VoidCallback onTap,
    required Color color,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose == true ? Colors.blueGrey.shade800 : color),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.blueGrey.shade800 : color,
        ),
        child: Center(
            child: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
