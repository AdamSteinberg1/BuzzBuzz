import 'package:flutter/material.dart';
import 'Options.dart';
import 'main.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:buzz_buzz_app/CalibrationRoute.dart';


class OptionsRoute extends StatefulWidget {
  static const String routeName = "/options";
  const OptionsRoute({Key? key}) : super(key: key);
  @override
  _OptionsRoute createState() => _OptionsRoute();
}
class _OptionsRoute extends State<OptionsRoute>{

  // Initial Selected Value
  int modeDropDown = 0;
  static const Map<int, String> modeNames = {
    0 : 'Buzz Mode',
    1 : 'False Heart Rate Matched',
    2 : 'False Heart Rate Gradual',
    3 : 'Breathing Guide',
  };

  @override
  void initState() {
    super.initState();
    options.getBuzzMode().then((value){
      setState(() {
        modeDropDown = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
                elevation: 10,
            child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ConstrainedBox(
                  constraints:BoxConstraints.expand(height: 50.0, width:MediaQuery.of(context).size.width),
                  child:DropdownButton<int>(
                    isExpanded: true,
                    alignment: AlignmentDirectional.centerEnd,
                    //Initial Value
                    value: modeDropDown,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: modeNames.entries.map((e) => DropdownMenuItem(value:e.key, child: Text(e.value))).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (int? newValue) {
                      if(newValue != null) {
                        setState(() {
                          modeDropDown = newValue;
                          options.setBuzzMode(newValue);
                        });
                      }
                    },
                  )
                ),
              )
            ),
            const SizedBox(width:10,height:10),
            Card(
                elevation: 10,
            child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ConstrainedBox(
                  constraints:BoxConstraints.expand(height: 50.0, width:MediaQuery.of(context).size.width),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Do Not Disturb', style: TextStyle(fontSize: 16)),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(left:MediaQuery.of(context).size.width-273),
                          child: Transform.scale(
                              scale:.70,
                              child: RollingSwitch.icon(
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
                            )
                        ),
                      ]
                  ),
                ),
             )
            ),
            const SizedBox(width:10,height:20),

            ConstrainedBox(
            constraints:BoxConstraints.expand(height: 50.0, width:MediaQuery.of(context).size.width),
            child:ElevatedButton(
                      style: TextButton.styleFrom(
                        elevation: 10,
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, CalibrationRoute.routeName);
                      },
                      child: const Text('Calibrate'),
                    ),
            )
          ],
        ),
      ),
    );
  } //Widget
}
