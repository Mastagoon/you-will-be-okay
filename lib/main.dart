import 'package:flutter/material.dart';
import 'package:timerapp/screens/counter.dart';
import './screens/home.dart';
import 'constants/colors.dart';

void main() => runApp(MaterialApp(
  title: "And then you'll be okay",
  theme: ThemeData(primaryColor: Color(primaryColor)),
  home: Home(),
));