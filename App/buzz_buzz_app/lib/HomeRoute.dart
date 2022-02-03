import 'package:flutter/material.dart';

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
