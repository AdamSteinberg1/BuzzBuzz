import 'package:buzz_buzz_app/BioData.dart';
import 'package:flutter/material.dart';
import 'HomeRoute.dart';
import 'PairingRoute.dart';
import 'MoreDataRoute.dart';
import 'OptionsRoute.dart';
import 'BreathingRoute.dart';

final bioData = BioData();

void main() {
  runApp(MaterialApp(
    theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
    initialRoute: '/',
    routes: {
      '/': (context) => HomeRoute(),
      '/b': (context) => PairingRoute(),
      '/c': (context) => MoreDataRoute(),
      '/d': (context) => OptionsRoute(),
      '/e': (context) => BreathingRoute(),
    },
  ));
}




