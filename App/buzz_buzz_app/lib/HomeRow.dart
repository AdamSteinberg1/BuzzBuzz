
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
            child: ElevatedButton(
                child: Text('Guided Breathing'),
                onPressed: () {
                  Navigator.pushNamed(context, '/e');
                },
              )
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