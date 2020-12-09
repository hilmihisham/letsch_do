import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {

  AboutPage();

  @override
  Widget build(BuildContext context) {
    //  return Container(
    //    color: color,
    //  );
    return Scaffold(
      appBar: AppBar(
          title: Text('About'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'App built by hilmihisham using Flutter during my downtime in this weird time of quarantine.',
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            ),
            Text(
              'version 0.1.5',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
    );
  }
}