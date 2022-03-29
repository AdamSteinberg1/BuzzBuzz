import 'package:buzz_buzz_app/BuzzButton.dart';
import 'package:buzz_buzz_app/MoreDataRoute.dart';
import 'package:buzz_buzz_app/OptionsRoute.dart';
import 'package:buzz_buzz_app/PairingRoute.dart';
import 'package:flutter/material.dart';
import 'package:buzz_buzz_app/bpmGraphic.dart';

import 'BreathingRoute.dart';

class HomeRoute extends StatelessWidget {
  static const String routeName = "/";
  const HomeRoute({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
                  Navigator.pushNamed(context, MoreDataRoute.routeName);
                },
                child: const Text('See More Data'),
              ),
            Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children:[
                  Container(
                    margin: const EdgeInsets.all(10),
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
                              Navigator.pushNamed(context, BreathingRoute.routeName);
                            },
                            child: const Text('Guided Breathing'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
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
                              Navigator.pushNamed(context, PairingRoute.routeName);
                            },
                            child: const Text('Pair Device'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
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
                              Navigator.pushNamed(context, OptionsRoute.routeName);
                            },
                            child: const Text('Options'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const BuzzButton(),
                ]),

            ],
          )),
    );
  }
}
