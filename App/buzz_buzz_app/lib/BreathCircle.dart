import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  void initState() {
    _animationController = AnimationController(vsync: this,duration: const Duration(milliseconds:5200), reverseDuration: const Duration(milliseconds:4500));
    _curve = CurvedAnimation(parent: _animationController, curve:Curves.easeInOut);
    _animation = Tween(begin:0.0, end:100.0).animate(_curve)..addListener(() {
      setState(() {

      });
    });
    super.initState();
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        // custom code here
        setState(() {
          breath="Breathe out";
        });
        _animationController.reverse();
      }
      else if(status == AnimationStatus.dismissed) {
        setState(() {
          breath="Breathe in";
        });
        _animationController.forward();
      }
    });

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
                      color: Colors.lightBlueAccent,
                      width: 0.95,
                      pointerOffset: 0.05,
                      sizeUnit: GaugeSizeUnit.factor,
                    )
                  ],
                )
              ]
            ),
          Container(
                  width: 350,
                  height:350,
                  child: Center(
                    child:Text(
                      breath,
                      style: const TextStyle(fontSize: 46, color: Colors.black26, fontWeight: FontWeight.w400),
                    ),

                  ),
                  decoration: const BoxDecoration(
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