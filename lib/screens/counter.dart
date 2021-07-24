import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'home.dart';

class Countdown extends StatefulWidget {
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Duration duration = Duration();
  Timer? timer;
  bool timerActive = false;

  static Future<int> getCountdownTarget() async {
    final _prefs = await SharedPreferences.getInstance();
    final countdownDate = _prefs.getInt("countdownDate");
    print("cdd val: $countdownDate");
    print(
        "cdd val: ${DateTime.fromMillisecondsSinceEpoch(countdownDate ?? 0)}");
    return countdownDate ?? 0;
  }

  static Future<void> removeCountdownTarget() async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt("countdownDate", 0);
  }

  @override
  void initState() {
    super.initState();
    print("initilized State");
    startTimer();
  }

  void startTimer() async {
    final countDownTarget = await getCountdownTarget();
    if (countDownTarget == 0) {
      // no timer
      stopTimer();
    } else {
      timerActive = true;
      final temp = DateTime.fromMicrosecondsSinceEpoch(countDownTarget);
      duration = Duration(
          days: temp.day,
          hours: temp.hour,
          minutes: temp.minute,
          seconds: temp.second);
      timer = Timer.periodic(Duration(seconds: 1), (_) => updateTime());
    }
  }

  void stopTimer() async {
    if (timer!.isActive) timer!.cancel();
    timerActive = false;
    await removeCountdownTarget();
    setState(() {
      duration = Duration(days: 0, hours: 0, minutes: 0, seconds: 0);
    });
  }

  void updateTime() {
    if (this.mounted) {
      setState(() {
        final seconds = duration.inSeconds - 1;
        duration = Duration(seconds: seconds);
      });
      if (duration.inSeconds <= 0) {
        // stop timer
        stopTimer();
      }
    }
  }

  void toggleTimer() {
    // pause
    if (timer!.isActive) {
      timer?.cancel();
      setState(() {
        timerActive = false;
      });
      return;
    }
    // resume
    timer = Timer.periodic(Duration(seconds: 1), (_) => updateTime());
    setState(() {
      timerActive = true;
    });
  }

  void cancelTimer() {
    BuildContext dialogContext;
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Are you sure you want to cancel this timer?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                stopTimer();
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text("Cancel"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("And then you'll be okay"),
          backgroundColor: Color(primaryColor),
        ),
        backgroundColor: Color(secondaryColor),
        body: Center(
          child: buildTime(),
        ));
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = twoDigits(duration.inHours);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Only",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        Center(
          // decoration: BoxDecoration(background),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTimeCard(time: hours, header: "HOURS"),
              const SizedBox(width: 8),
              buildTimeCard(time: minutes, header: "MINUTES"),
              const SizedBox(width: 8),
              buildTimeCard(time: seconds, header: "SECONDS"),
            ],
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: "Remain.",
            ),
            TextSpan(
                text: " And then you'll be okay.",
                style: TextStyle(color: Colors.purple[400]))
          ]),
        ),
        const SizedBox(height: 16),
        duration.inSeconds > 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: toggleTimer,
                    child: Text(
                      timerActive ? "PAUSE" : "RESUME",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: cancelTimer,
                    child: Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(width: 2, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            : OutlinedButton(
                onPressed: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home())),
                child: Text(
                  "Set New Timer",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    BorderSide(width: 2, color: Colors.white),
                  ),
                ),
              ),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // decoration: BoxDecoration(color: Colors.white),
            child: Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 72),
            ),
          ),
          Text(
            header,
            style: TextStyle(color: Colors.white),
          )
        ],
      );
}
