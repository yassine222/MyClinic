// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import 'package:testa/quotes.dart';

class QuoteCard extends StatelessWidget {
  final Quotes quotes;
  final Function() delete;
  // final Function() showAlertDialog;
  QuoteCard({required this.quotes, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(children: <Widget>[
            Text(quotes.text,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.greenAccent,
                )),
            const SizedBox(
              height: 6.0,
            ),
            Text(quotes.author,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.lightGreen,
                )),
            SizedBox(height: 8.0),
            ElevatedButton.icon(
              onPressed: () {
                showAlertDialog(context);
              },
              label: Text('delete quote'),
              icon: Icon(Icons.delete),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            )
          ]),
        ));
  }

  showAlertDialog(
    BuildContext context,
  ) {
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      onPressed: (delete),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Would you like to Delete this quote?"),
      actions: [
        cancelButton,
        continueButton,
      ],
      // Rect.fromCircle(center: 0, radius: 100),
    );
    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
        barrierDismissible: false);
  }
}
