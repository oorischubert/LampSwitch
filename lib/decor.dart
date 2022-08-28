import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Decor {
  //function to add border and rounded edges to our form
  static OutlineInputBorder inputformdeco() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: const BorderSide(
          width: 1.0, color: Colors.blue, style: BorderStyle.solid),
    );
  }
}

class ScaledBox extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const ScaledBox(
      {Key? key,
      required this.child,
      required this.height,
      required this.width
      })
      : super(key: key);

  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: FittedBox(child: child));
  }
}
