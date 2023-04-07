import 'package:flutter/material.dart';

class AppTheme {
  /// default application theme
  static ThemeData get basic => ThemeData(
        primaryColorDark: const Color.fromRGBO(51, 41, 161, 1.0),
        primaryColor: const Color.fromRGBO(37, 27, 86, 1.0),
        primaryColorLight: const Color.fromRGBO(44, 30, 154, 1.0),
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(39, 26, 141, 1.0),
        ).merge(
          ButtonStyle(elevation: MaterialStateProperty.all(0)),
        )),
        canvasColor: const Color.fromRGBO(201, 206, 243, 1.0),
        cardColor: const Color.fromRGBO(201, 206, 243, 1.0),
      );
}
