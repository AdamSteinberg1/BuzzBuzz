import 'package:flutter/material.dart';
class BluetoothRoute extends StatelessWidget {
  const BluetoothRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pair Bluetooth'),
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
