import 'package:buzz_buzz_app/CalibrationRoute.dart';

import 'BioData.dart';
import 'Options.dart';
import 'package:flutter/material.dart';
import 'HomeRoute.dart';
import 'PairingRoute.dart';
import 'MoreDataRoute.dart';
import 'OptionsRoute.dart';
import 'BreathingRoute.dart';

final bioData = BioData();
final options = Options();

void main() {
  runApp(MaterialApp(
    theme: ThemeData(scaffoldBackgroundColor: Colors.white),
    initialRoute: HomeRoute.routeName,
    routes: {
      HomeRoute.routeName : (context) => const HomeRoute(),
      PairingRoute.routeName : (context) => const PairingRoute(),
      MoreDataRoute.routeName : (context) => const MoreDataRoute(),
      OptionsRoute.routeName : (context) => const OptionsRoute(),
      BreathingRoute.routeName : (context) => const BreathingRoute(),
      CalibrationRoute.routeName : (context) => const CalibrationRoute(),
    },
  ));
}




