import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
class waterBox extends StatefulWidget {
  const waterBox({Key? key}) : super(key: key);
  @override
  _waterBox createState() => _waterBox();
}
class _waterBox extends State<waterBox> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation _animation;
  late Animation<double> _curve;
  String breath="Breathe in";
  @override
  void initState() {
    _animationController = AnimationController(vsync: this,duration: Duration(milliseconds:2000));
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
              Container(
              width: 250,
              height: _animation.value,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              )
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
                        child:Text(breath, style: TextStyle(fontSize: 42, color: Colors.black26, fontWeight: FontWeight.w400),),

                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black, width:3)
                      )
                  )
              )
            ],
          )
        ]
    );
  }

}