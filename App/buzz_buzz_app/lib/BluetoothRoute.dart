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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            CircularProgressIndicator(),
            SizedBox(height: 20.0),
            ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('go home'),
          ),
        ]
        ),
      )

    );
  }
}
