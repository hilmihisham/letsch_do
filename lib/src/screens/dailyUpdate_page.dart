import 'package:flutter/material.dart';

// class for daily update screen, accessible via notification or sidebar menu
class DailyUpdatePage extends StatelessWidget {
  
  final String payload;

  DailyUpdatePage({
    @required this.payload,
  });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Update'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                getGreetingsByTime(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            ),
          ],
        ),
    );
  }
}