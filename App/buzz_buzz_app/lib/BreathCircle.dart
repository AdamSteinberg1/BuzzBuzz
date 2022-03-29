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
class _breathCircle extends State<breathCircle>{

  final _colors = <Color>[Colors.lightBlue];
  final _colorLengths = <double>[1];
  Color bpmTextColor=Colors.blue;

  late AnimationController _animationController;
  late Animation _animation;
  late Animation<double> _curve;
  String breath="Breathe in";
  @override
  void initState() {
    _animationController = AnimationController(vsync: this,duration: Duration(milliseconds:3500));
    _curve = CurvedAnimation(parent: _animationController, curve:Curves.easeInOutCubic);
    _animation = Tween(begin:0.0, end:250.0).animate(_curve)..addListener(() {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<bool>(
            initialData: bioData.currentlyConnected(),
            stream: bioData.deviceConnected(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              final bool connected = snapshot.data ?? false;
              return StreamBuilder<double>(
                stream: bioData.heartRateStream(),
                builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                  double bpm = snapshot.data ?? 0.0;
                  return SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          showLabels: false,
                          showTicks: false,
                          startAngle: 270,
                          endAngle: 270,
                          axisLineStyle: AxisLineStyle(
                            thickness: 0.05,
                            color: const Color.fromARGB(100, 0, 169, 181),
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
                  );
                },
              );
            }
        )
    );
  }

}