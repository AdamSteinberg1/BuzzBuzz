import 'package:flutter/material.dart';
import 'main.dart';

class CalibrationRoute extends StatelessWidget {
  const CalibrationRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calibrate Resting Heart Rate'),
      ),
      body: StreamBuilder<bool>(
        stream: bioData.deviceConnected(),
        initialData: bioData.currentlyConnected(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data ?? false) {
            return const Text("Connected");
          } else {
            return const Disconnected();
          }
        },
      ),
    );
  }
}

class Disconnected extends StatelessWidget {
  const Disconnected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.bluetooth_disabled,
              size: 70,
              color: Colors.grey,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('You cannot calibrate when the BuzzBuzz Bracelet is disconnected.',
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              child: const Text('Pair Device'),
              onPressed: () {
                Navigator.pushNamed(context, '/b');
              },
            ),
          ],
        ),
      ),
    );
  }
}


