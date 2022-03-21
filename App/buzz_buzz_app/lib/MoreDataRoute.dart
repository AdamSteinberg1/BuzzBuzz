import 'dart:ui';

import 'package:buzz_buzz_app/TextSection.dart';
import 'package:buzz_buzz_app/ColorBox.dart';
import 'package:buzz_buzz_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'textSection.dart';
class MoreDataRoute extends StatelessWidget {
  const MoreDataRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          SizedBox(height: 10),
          TextSection('Daily HR and Movement'),
          ColorBox('Insert Graph', Colors.blueAccent),
          SizedBox(height: 10),
          TextSection('Anxiety Detected Today'),
          ColorBox('Insert Graph', Colors.blueGrey),
          SizedBox(height: 10),
          TextSection('Weekly HR and Movement'),
          ColorBox('Insert Graph', Colors.lightBlue),
          SizedBox(height: 10),
          TextSection('Detected Anxiety This Week'),
          ColorBox('Insert Graph', Colors.blue),
        ElevatedButton(
          onPressed: bioData.exportData,
          child: const Text("Export Data"),
        ),

        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('go home'),
          ),
          ]
        ),
      ),
    );
  }
}
