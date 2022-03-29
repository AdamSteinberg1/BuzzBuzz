import 'package:flutter/material.dart';
import 'package:buzz_buzz_app/WaterCup.dart';
import 'package:buzz_buzz_app/WaterBox.dart';
import 'package:buzz_buzz_app/BreathCircle.dart';
class BreathingRoute extends StatelessWidget {
  static const String routeName = "/breathing";
  const BreathingRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Breathing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            //waterBox(),
            //waterCup(),
            breathCircle(),
            SizedBox(width:10,height:20),
          ],
        ),
      ),
    );
  }
}