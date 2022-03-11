import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



class OptionsRoute extends StatefulWidget {
  const OptionsRoute({Key? key}) : super(key: key);
  @override
  _OptionsRoute createState() => _OptionsRoute();
}
class _OptionsRoute extends State<OptionsRoute>{

  // Initial Selected Values
  static String modeDropDown = 'Buzz Mode';
  //static String intensityDropDown = 'Buzz Intensity';
  // List of items in our dropdown menu
  var buzzModes = <String>[
    'Buzz Mode',
    'False Heart Rate Matched',
    'False Heart Rate Gradual',
    'Breathing Guide',
  ];
  /*var intensities = [
    'Buzz Intensity',
    'Low intensity',
    'Moderate intensity',
    'High intensity',
  ];*/
  Future<String> getLocalPath() async{
    var dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> getLocalFile() async{
    String path = await getLocalPath();
    return File('$path/OptionsData.txt');
  }

  Future<File> writeOptions(String s) async{
    File file = await getLocalFile();
    return file.writeAsString(s);
  }
  Future<String> readOptions() async{
    try{
      final file= await getLocalFile();
      String contents = await file.readAsString();
      return contents;
    }catch(e){
      return "Null";
    }
  }
   //example of file read
  @override
  void initState() {
    super.initState();
    readOptions().then((data){
      setState((){
        buzzModes.forEach((buzzmode) {
          if(data == buzzmode) {
            modeDropDown = buzzmode;
            print('Buzz mode read in');
          }
        });
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
            DropdownButton(
              //Initial Value
              value: modeDropDown,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: buzzModes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  modeDropDown = newValue!;
                });
                writeOptions(modeDropDown);
              },
            ),
            /*DropdownButton(
              // Initial Value
              value: intensityDropDown,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: intensities.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  intensityDropDown = newValue!;
                });
              },
            ), */
            SizedBox(width:10,height:20),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.blue,
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  } //Widget
}

