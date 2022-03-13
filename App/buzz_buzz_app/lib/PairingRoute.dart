import 'package:buzz_buzz_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'dart:math';

// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class PairingRoute extends StatelessWidget {
  const PairingRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BluetoothState>(
          stream: FlutterBluePlus.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return const BluetoothOnScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class Connected extends StatelessWidget {
  const Connected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Connected"),
            ElevatedButton.icon(
                icon: const Icon(Icons.bluetooth),
                onPressed: () {
                  bioData.disconnectFromDevice();
                },
                label: const Text("Disconnect")),
          ],
        )
    );
  }
}

class NotConnected extends StatefulWidget {
  const NotConnected({Key? key}) : super(key: key);

  @override
  State<NotConnected> createState() => _NotConnectedState();
}

class _NotConnectedState extends State<NotConnected> {
  bool tryingToConnect = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Not Connected"),
            ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth),
                onPressed: () {
                  setState(() {
                    tryingToConnect = true;
                  });
                  bioData.connectToDevice();
                },
                label: const Text("Connect")),
            if(tryingToConnect)
              const CircularProgressIndicator()
          ]
      ),
    );
  }
}

class BluetoothOnScreen extends StatelessWidget {
  const BluetoothOnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: bioData.deviceConnected(),
      initialData: bioData.currentlyConnected(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.data ?? false) {
          return const Connected();
        } else {
          return const NotConnected();
        }
      },
    );
  }
}