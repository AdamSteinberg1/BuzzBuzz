import 'package:flutter/material.dart';
class BreathingRoute extends StatelessWidget {
  const BreathingRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Breathing'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('go home'),
        ),

      ),
    );
  }
}