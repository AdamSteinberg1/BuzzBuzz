import 'package:flutter/material.dart';
import 'Options.dart';
import 'main.dart';


class OptionsRoute extends StatefulWidget {
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
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            DropdownButton<int>(
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
            ),
            const SizedBox(width:10,height:20),
          ],
        ),
      ),
    );
  } //Widget
}

