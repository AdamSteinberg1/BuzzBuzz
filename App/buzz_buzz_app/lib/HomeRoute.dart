import 'package:buzz_buzz_app/BuzzButton.dart';
import 'package:flutter/material.dart';
import 'package:buzz_buzz_app/TextSection.dart';
import 'package:buzz_buzz_app/ColorBox.dart';
import 'package:buzz_buzz_app/HomeRow.dart';
import 'package:buzz_buzz_app/bpmGraphic.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              bpmGraphic(),
              //ColorBox('Insert Graph',Colors.lightBlue),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/c');
                },
                child: const Text('See More Data'),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: const HomeRow(),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/b');
                        },
                        child: const Text('Pair Device'),
                      ),
                    ],
                  ),
                ),
              ),
            Container(
              margin: EdgeInsets.all(15),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/d');
                        },
                        child: const Text('Options'),
                      ),
                    ],
                  ),
                ),
               ),
            BuzzButton(),
            ],
          )),
    );
  }
}
