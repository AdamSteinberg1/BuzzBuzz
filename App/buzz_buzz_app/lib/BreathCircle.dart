import 'package:buzz_buzz_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class breathCircle extends StatefulWidget {
  const breathCircle({Key? key}) : super(key: key);
  @override
  _breathCircle createState() => _breathCircle();
}
class _breathCircle extends State<breathCircle> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation _animation;
  late Animation<double> _curve;
  String breath="Breathe in";
  @override
  //4500 breathe out
  void initState() {
    _animationController = AnimationController(vsync: this,duration: Duration(milliseconds:5200), reverseDuration: Duration(milliseconds:4500));
    _curve = CurvedAnimation(parent: _animationController, curve:Curves.easeInOut);
    _animation = Tween(begin:0.0, end:100.0).animate(_curve)..addListener(() {
      setState(() {

      });
    });
    super.initState();
    _animationController.addListener(() {
      setState(() {});
    });

    // Repeat the animation after finish
    /*if(_animationController.isCompleted){
      _animationController.reverse();
      breath="Breathe out";
    }
    else{
      _animationController.forward();
      breath="Breathe in";
    }*/
    _animationController.repeat(reverse: true);
  }
  bool createListener(){
    /*_animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation completed
        breath="Breathe out";
      } else if (status == AnimationStatus.dismissed) {
        // Reverse animation completed
        breath="Breathe in";
      }
      return status;
    });
    return false;*/
    bool complete=false;
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        complete = true;
      }
    }
    );
    return complete;

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 100,
                  showLabels: false,
                  showTicks: false,
                  startAngle: 270,
                  endAngle: 270,
                  axisLineStyle: const AxisLineStyle(
                    thickness: 0.05,
                    color: Color.fromARGB(100, 0, 169, 181),
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: _animation.value,
                      width: 0.95,
                      pointerOffset: 0.05,
                      sizeUnit: GaugeSizeUnit.factor,
                    )
                  ],
                )
              ]
            ),
          Container(
                  width: 330,
                  height:330,
                  child: Center(
                    child:Text(
                      createListener() ? "Breathe out" : "Breath in",
                      //breath,
                      style: TextStyle(fontSize: 42, color: Colors.black26, fontWeight: FontWeight.w400),
                    ),

                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      //border: Border.all(color: Colors.black, width:3)
                  )
              )
          ]
          )
        ]
      );
  }

}