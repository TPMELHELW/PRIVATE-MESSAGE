import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  Button(
      {super.key,
      required this.title,
      required this.color,
      required this.pressed});
  String? title;
  Color? color;
  // ignore: prefer_typing_uninitialized_variables
  var pressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const StadiumBorder(),
        ),
        onPressed: pressed,
        child: Text(
          "$title",
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
