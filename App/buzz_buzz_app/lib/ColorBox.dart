import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorBox extends StatelessWidget {
  final String _text;
  final Color _color;

  ColorBox(this._text,this._color);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        constraints: const BoxConstraints.expand(
        height: 200.0,
    ),
    decoration:BoxDecoration(color: _color),
    child:Text(_text),
    );
  }
}