import 'package:flutter/material.dart';
import 'package:buzz_buzz_app/WaterCup.dart';
import 'package:buzz_buzz_app/WaterBox.dart';
class BreathingRoute extends StatelessWidget {
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
            waterCup(),
            SizedBox(width:10,height:20),
          ],
        ),
      ),
    );
  }
}