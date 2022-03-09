import 'package:flutter/material.dart';
import 'HomeRoute.dart';
import 'BluetoothRoute.dart';
import 'MoreDataRoute.dart';
import 'OptionsRoute.dart';
import 'BreathingRoute.dart';



void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomeRoute(),
      '/b': (context) => BluetoothRoute(),
      '/c': (context) => MoreDataRoute(),
      '/d': (context) => OptionsRoute(),
      '/e': (context) => BreathingRoute(),
    },
  ));
}




