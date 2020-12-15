import 'dart:math';

import 'package:flutter/material.dart';
import 'package:letsch_do/src/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

// class for daily update screen, accessible via notification or sidebar menu
class DailyUpdatePage extends StatefulWidget {
  
  final String payload;

  DailyUpdatePage({
    @required this.payload,
  });

  @override
  _DailyUpdatePageState createState() => _DailyUpdatePageState();
}

class _DailyUpdatePageState extends State<DailyUpdatePage> {

  DatabaseHelper databaseHelper = DatabaseHelper();

  // yesterday's message
  int ytdDoneCount = 0;
  String ytdDoneMsg = "";


  String getGreetingsByTime() {
    DateTime currentTime = DateTime.now();
    debugPrint("current time | hour = " + currentTime.toString() + " | " + currentTime.hour.toString());

    if (currentTime.hour < 12) {
      return "Good morning!";
    }
    else if (currentTime.hour >= 12 && currentTime.hour < 17) {
      return "Good afternoon!";
    }
    else {
      return "Good evening!";
    }
  }

  // 20201215 yesterday's task message [start]
  void getYesterdayLogCount() {

    debugPrint("getYesterdayLogCount() start");

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    
    List<String> randomMsg = [
      "Keep up the good work!",
      "Awesome!",
      "Great job!",
      "You rocks!",
      "Noice!",
      "Cool!",
      "Brilliant!"
    ];

    dbFuture.then((database) {
      var ytdCount = databaseHelper.getYesterdayDoneTaskCount();
      ytdCount.then((value) => {
        setState(() {
          this.ytdDoneCount = value;

          if (value > 0) {
            // int randomizer = new Random().nextInt(7),
            this.ytdDoneMsg = "You've finished " + value.toString() + " tasks yesterday. " + randomMsg.elementAt(Random().nextInt(7));
          }
          else {
            this.ytdDoneMsg = "No finished task recorded yesterday. Well, people need break every now and then too.";
          }
        }),
      });
    });

    debugPrint("getYesterdayLogCount() end");
  }
  // 20201215 yesterday's task message [end]

  @override
  void initState() {
    getYesterdayLogCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Update'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                getGreetingsByTime(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            ),

            // 20201215 yesterday's task message [start]
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                this.ytdDoneMsg,
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            ),
            // 20201215 [end]
          ],
        ),
      ),
    );
  }
}