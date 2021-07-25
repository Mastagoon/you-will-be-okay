import 'package:flutter/material.dart';
import 'package:timerapp/constants/colors.dart';
// import 'counter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timerapp/screens/counter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<int> getCountdownTarget() async {
    final _prefs = await SharedPreferences.getInstance();
    final countdownDate = _prefs.getInt("countdownDate");
    return countdownDate ?? 0;
  }

  Future<void> setDateToPref(countdownDate) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setInt("countdownDate", countdownDate);
  }

  void screenCheck() async {
    int countdownDate = await getCountdownTarget();
    // no countdownTarget selected
    if (countdownDate == 0) return;
    // there is a countdownTarget
    // check if it's in the past
    if (DateTime.fromMillisecondsSinceEpoch(countdownDate)
        .difference(DateTime.now())
        .isNegative) return;
    // there is a countodnwTarget and it's not negative
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Countdown()));
  }

  void selectDate() async {
    // select date
    final _date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (_date == null) return;
    // select time
    final _time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (_time == null) return;
    final _dt = new DateTime(
            _date.year, _date.month, _date.day, _time.hour, _time.minute)
        .millisecondsSinceEpoch;
    await setDateToPref(_dt);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Countdown()));
  }

  @override
  Widget build(BuildContext context) {
    screenCheck();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(secondaryColor),
        appBar: AppBar(
          title: Text("And then you'll be okay"),
          backgroundColor: Color(primaryColor),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(children: [
                Container(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: Text(
                    "New Disaster",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  child: Text(
                      "Having a bad time?\n select the date when the bad time will end.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300)),
                ),
              ]),
              Column(
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () => selectDate(),
                      child: IconButton(
                          onPressed: () => selectDate(),
                          icon: Icon(Icons.alarm)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(secondaryColor)),
                          side: MaterialStateProperty.all(
                              BorderSide(width: 2, color: Colors.white)),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(5))),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 50),
                    child: Text(
                      "Select Date",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
