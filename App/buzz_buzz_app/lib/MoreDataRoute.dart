import 'dart:ui';

import 'package:buzz_buzz_app/TextSection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'textSection.dart';
class MoreDataRoute extends StatelessWidget {
  const MoreDataRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Data'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        TextSection('Weekly HR and Movement'),
        Container(
          constraints: const BoxConstraints.expand(
            height: 200.0,
          ),
          decoration: const BoxDecoration(color: Colors.blueGrey),
          child: const Text('Insert Graph'),
        ),
        TextSection('Detected Anxiety Graph'),
        Container(
          constraints: const BoxConstraints.expand(
            height: 200.0,
          ),
          decoration: const BoxDecoration(color: Colors.blue),
          child: const Text('Insert Graph'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('go home'),
        ),
        ]
      ),
    );
  }
}
