import 'package:flutter/material.dart';

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

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Text('Pair Device'),
                onPressed: () {
                  Navigator.pushNamed(context, '/b');
                },
              ),
              ElevatedButton(
                child: Text('See More Data'),
                onPressed: () {
                  Navigator.pushNamed(context, '/c');
                },
              ),
              ElevatedButton(
                child: Text('Go to Options'),
                onPressed: () {
                  Navigator.pushNamed(context, '/d');
                },
              ),
              ElevatedButton(
                child: Text('Go to Guided Breathing'),
                onPressed: () {
                  Navigator.pushNamed(context, '/e');
                },
              ),
            ],
          )),
    );
  }
}

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

class MoreDataRoute extends StatelessWidget {
  const MoreDataRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Data'),
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
class OptionsRoute extends StatefulWidget {
  const OptionsRoute({Key? key}) : super(key: key);

  @override
  _OptionsRoute createState() => _OptionsRoute();
}
class _OptionsRoute extends State<OptionsRoute> {

  // Initial Selected Values
  String modeDropDown = 'Buzz Mode';
  String intensityDropDown = 'Buzz Intensity';
  String notificationsDropDown = 'Notifications';

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
              // Initial Value
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
          ],
        ),
      ),
    );
  }
}

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