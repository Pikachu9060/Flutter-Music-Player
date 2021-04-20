import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomIcon extends StatelessWidget {
  CustomIcon({this.height, this.width, this.child, this.function});
  double height, width;
  Function function;
  Widget child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function ?? null,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Color(0xFFE5EEFC), //darkblue
              width: 2),
          boxShadow: [
            BoxShadow(
              color: Color(0xAA92AEFF), //lightblueshadow
              blurRadius: 10,
              offset: Offset(5, 5),
              spreadRadius: 3,
            ),
            BoxShadow(
              color: Colors.white, //lightblueshadow
              blurRadius: 5,
              offset: Offset(-1, -1),
              spreadRadius: 3,
            ),
          ],
          gradient: RadialGradient(
            colors: [
              Color(0xFFE5EEFC),
              Color(0xFFE5EEFC),
              Color(0xFFE5EEFC),
              Colors.white,
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
