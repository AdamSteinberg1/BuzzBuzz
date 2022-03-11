
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rolling_switch/rolling_switch.dart';

class HomeRow extends StatefulWidget {
  const HomeRow({Key? key}) : super(key: key);

  @override
  State<HomeRow> createState() => _HomeRow();
}
class _HomeRow extends State<HomeRow> {

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(20),
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
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/e');
                    },
                    child: const Text('Guided Breathing'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width:20.0),
          Column(
            children: [
              Text('Do Not Disturb'),
              RollingSwitch.icon(
                onChanged: (bool state) {
                  print('turned ${(state) ? 'on' : 'off'}');
                },
                rollingInfoRight: const RollingIconInfo(
                  icon: Icons.alarm_off,
                  backgroundColor: Colors.lightBlue,
                  text: Text('On'),
                ),
                rollingInfoLeft: const RollingIconInfo(
                  icon: Icons.alarm,
                  backgroundColor: Colors.grey,
                  text: Text('Off'),
                ),
              ),
            ]
          )
        ]
    );
  }
}