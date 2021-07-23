import 'package:flutter/material.dart';
import '../constants/colors.dart';

class Countdown extends StatefulWidget {
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("And then you'll be okay"),
          backgroundColor: Color(primaryColor),
        ),
      backgroundColor: Color(secondaryColor),
    );
  }
}
