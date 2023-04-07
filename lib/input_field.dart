// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final int? maxlength;
  final TextInputType? inputType;
  final String title;
  final String? hint;
  final TextEditingController? controller;
  final Widget? widget;
  final String? initialValue;
  const InputField(
      {super.key,
      required this.title,
      this.hint,
      this.controller,
      this.inputType,
      this.maxlength,
      this.initialValue,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 14),
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: initialValue,
                    maxLength: maxlength,
                    keyboardType: inputType,
                    readOnly: widget == null ? false : true,
                    decoration: InputDecoration(
                        hintText: hint,
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    controller: controller,
                    autofocus: false,
                    cursorColor: Colors.white,
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
