import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
class waterCup extends StatefulWidget {
  const waterCup({Key? key}) : super(key: key);
  @override
  _waterCup createState() => _waterCup();
}
class _waterCup extends State<waterCup> with SingleTickerProviderStateMixin{

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
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Trapezoid(
                cutLength: 25.0,
                edge: Edge.BOTTOM,
                clipShadows: [ClipShadow(color: Colors.black54)],
                child: Container(
                  color: Colors.black,
                  width: 253.0,
                  height: 252,
                ),
              ),
              Trapezoid(
                cutLength: 25.0,
                edge: Edge.BOTTOM,
                clipShadows: [ClipShadow(color: Colors.black54)],
                child: Container(
                  color: Colors.white,
                  width: 250.0,
                  height: 250,
                ),
              ),
              Trapezoid(
                cutLength: _animation.value/10.0,
                edge: Edge.BOTTOM,
                clipShadows: [ClipShadow(color: Colors.black54)],
                child: Container(
                  color: Colors.blue,
                  width: _animation.value,
                  height: _animation.value,
                ),
              ),
              GestureDetector(
                  onTap:() {
                    if(_animationController.isCompleted){
                      _animationController.reverse();
                      breath="Breathe out";
                    }
                    else{
                      _animationController.forward();
                      breath="Breathe in";
                    }
                  },
                  child: Container(
                      width: 250,
                      height:250,
                      child: Center(
                        child:Text(breath, style: TextStyle(fontSize: 40, color: Colors.black26, fontWeight: FontWeight.w400),),

                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.transparent)
                      )
                  )
              )
            ],
          )
        ]
    );
  }

}