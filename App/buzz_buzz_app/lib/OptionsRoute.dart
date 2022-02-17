import 'package:flutter/material.dart';



class OptionsRoute extends StatefulWidget {
  const OptionsRoute({Key? key}) : super(key: key);
  @override
  _OptionsRoute createState() => _OptionsRoute();
}
class _OptionsRoute extends State<OptionsRoute>{

  // Initial Selected Values
  static String modeDropDown = 'Buzz Mode';
  static String intensityDropDown = 'Buzz Intensity';
  static String notificationsDropDown = 'Notifications';
  // List of items in our dropdown menu
  var buzzModes = <String>[
    'Buzz Mode',
    'False Heart Rate Matched',
    'False Heart Rate Gradual',
    'Breathing Guide',
  ];
  var intensities = [
    'Buzz Intensity',
    'Low intensity',
    'Moderate intensity',
    'High intensity',
  ];
  var notifications = [
    'Notifications',
    'All notifications',
    'Only detected anxiety notifications',
    'No notifications',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            DropdownButton(
              //Initial Value
              value: modeDropDown,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: buzzModes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  modeDropDown = newValue!;
                });
              },
            ),
            DropdownButton(
              // Initial Value
              value: intensityDropDown,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: intensities.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  intensityDropDown = newValue!;
                });
              },
            ),
            DropdownButton(
              // Initial Value
              value: notificationsDropDown,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: notifications.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  notificationsDropDown = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('go home'),
            ),
          ],
        ),
      ),
    );
  } //Widget
}

