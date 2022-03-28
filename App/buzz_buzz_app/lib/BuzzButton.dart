import 'package:buzz_buzz_app/main.dart';
import 'package:flutter/material.dart';

class BuzzButton extends StatefulWidget {
  const BuzzButton({Key? key}) : super(key: key);

  @override
  State<BuzzButton> createState() => _BuzzButtonState();
}

class _BuzzButtonState extends State<BuzzButton> {
  bool _buzzing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              onPressed: () async {
                if(_buzzing) {
                  bioData.activateMotor(0);
                } else {
                  bioData.activateMotor(await options.getBuzzMode());
                }
                setState(() {
                  _buzzing = !_buzzing;
                });
              },
              child: _buzzing ? const Text("Stop Buzzing") : const Text("Buzz Me")
            ),
          ],
        ),
      ),
    );
  }
}
