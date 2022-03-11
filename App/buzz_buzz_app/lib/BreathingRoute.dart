import 'package:flutter/material.dart';
import 'package:buzz_buzz_app/WaterCup.dart';
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
            waterCup(),
            SizedBox(width:10,height:20),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.blue,
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}