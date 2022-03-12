import 'package:buzz_buzz_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class bpmGraphic extends StatefulWidget {
  const bpmGraphic({Key? key}) : super(key: key);
  @override
  _bpmGraphic createState() => _bpmGraphic();
}
class _bpmGraphic extends State<bpmGraphic>{

  final _colors = <Color>[Colors.lightBlue];
  final _colorLengths = <double>[1];
  Color bpmTextColor=Colors.blue;
  //create list of colors from bpm

  Future<String> getLocalPath() async{
    var dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> getLocalFile() async{
    String path = await getLocalPath();
    return File('$path/currBPM.txt');
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
        //bpm=double.parse('$data');
        /*if(bpm>40)
          {
            _colors.add(Colors.green);
          }
        if(bpm>80)
        {
          _colors.add(Colors.yellow);
        }
        if(bpm>100)
        {
          _colors.add(Colors.orange);
        }
        if(bpm>150)
        {
          _colors.add(Colors.red);
        }*/
          }
        );
      });
    }

    //now that we have updated bpm we build the list of gradients
  void fillColors(double bpm) {
        print("colors being filled");
        _colors.clear();
        _colors.add(Colors.blue);
        if(bpm>40)
        {
          _colors.add(Colors.green);
          _colorLengths.clear();
          _colorLengths.addAll({.5,1});
          bpmTextColor=Colors.green;
        }
        if(bpm>80)
        {
          _colors.add(Colors.yellow);
          _colorLengths.clear();
          _colorLengths.addAll({.333,.666,1});
          bpmTextColor=Colors.yellow;
        }
        if(bpm>100)
        {
          _colors.add(Colors.orange);
          _colorLengths.clear();
          _colorLengths.addAll({.25,.5,.75,1});
          bpmTextColor=Colors.orange;
        }
        if(bpm>150)
        {
          _colors.add(Colors.red);
          _colorLengths.clear();
          _colorLengths.addAll({.2,.4,.6,.8,1});
          bpmTextColor=Colors.red;
        }
  }



  @override
  Widget build(BuildContext context) {
    print("colors in _colors are: $_colors");
    return SafeArea(
        child: StreamBuilder<double>(
          stream: bioData.heartRateStream(),
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            double bpm = snapshot.data ?? 0.0;
            fillColors(bpm);
            return SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                      axisLineStyle: AxisLineStyle(thickness: 0.3,thicknessUnit: GaugeSizeUnit.factor),
                      minimum: 0,
                      maximum: 200,
                      interval: 20,
                      //60-80 green 40-60 blue 80-100 yellow 100 red gradient 200 black
                      pointers: <GaugePointer>[
                        RangePointer(
                            value: bpm, width: 0.3, sizeUnit: GaugeSizeUnit.factor,
                            gradient: SweepGradient(
                                colors: _colors,
                                stops: _colorLengths
                            ),
                            //value: bpm,
                            enableAnimation: true
                        )
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(bpm.toStringAsFixed(2), style:TextStyle(color: bpmTextColor, fontSize: 40,fontWeight: FontWeight.bold)),
                          //horizontalAlignment: GaugeAlignment.near,
                          verticalAlignment: GaugeAlignment.center,
                          positionFactor:.15,
                          //angle: 90
                        )
                      ]
                  )
                ]
            );
          },
        )
    );
  }

}

/////////////////////////////////////////////////////////////////////
