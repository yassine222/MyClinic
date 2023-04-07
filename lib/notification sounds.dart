// ignore_for_file: prefer_const_constructors, unused_field, file_names, unnecessary_new

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Alarm extends StatefulWidget {
  const Alarm({Key? key}) : super(key: key);

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  final _audioQuery = new OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.music_note),
                )));
  }
}
