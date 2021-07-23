import 'package:flutter/material.dart';
import 'package:timerapp/constants/colors.dart';
import 'counter.dart';

class Home extends StatelessWidget {
  void selectDate(context) async {
    // select date
    final _date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (_date != null) {
      print("Selected Date: $_date");
      // select time
      final _time =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (_time != null) print("Selectedtime: $_time");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Countdown()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(secondaryColor),
        appBar: AppBar(
          title: Text("And then you'll be okay"),
          backgroundColor: Color(primaryColor),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
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

              // Container(
                 TextFormField(
                  decoration: InputDecoration(
                    labelText: "Disaster Name",
                    labelStyle: TextStyle(color: Colors.white),
                    helperText: "Select a name for this disaster",
                    helperStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                    ),
                  ),
                ),
              // ),
              Column(
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () => selectDate(context),
                      child: IconButton(
                          onPressed: () => selectDate(context),
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
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 100),
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

              // Container(
              //   child: ,
              // )
            ],
          ),
        ));
  }
}
