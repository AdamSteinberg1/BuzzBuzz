import 'dart:ui';

import 'package:buzz_buzz_app/TextSection.dart';
import 'package:buzz_buzz_app/ColorBox.dart';
import 'package:buzz_buzz_app/main.dart';
import 'package:flutter/material.dart';

class MoreDataRoute extends StatelessWidget {
  static const String routeName = "/moreData";
  const MoreDataRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Data'),
      ),
      body: ListView(
        children: [
          Image.asset("assets/moreDataGraphs/HourlyHR.png"),
          Image.asset("assets/moreDataGraphs/DailyHR.png"),
          Image.asset("assets/moreDataGraphs/WeeklyHR.png"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: ElevatedButton(
              onPressed: bioData.exportData,
              child: const Text("Export Data"),
            ),
          ),
        ],
      ),
    );
  }
}
