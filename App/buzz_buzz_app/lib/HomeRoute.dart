import 'package:flutter/material.dart';
import 'package:buzz_buzz_app/TextSection.dart';
import 'package:buzz_buzz_app/ColorBox.dart';
import 'package:buzz_buzz_app/HomeRow.dart';

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ColorBox('Insert Graph',Colors.lightBlue),
              ElevatedButton(
                child: Text('See More Data'),
                onPressed: () {
                  Navigator.pushNamed(context, '/c');
                },
              ),
              const HomeRow(),
              ElevatedButton(
                child: Text('Pair Device'),
                onPressed: () {
                  Navigator.pushNamed(context, '/b');
                },
              ),
              ElevatedButton(
                child: Text('Go to Options'),
                onPressed: () {
                  Navigator.pushNamed(context, '/d');
                },
              ),
            ],
          )),
    );
  }
}
