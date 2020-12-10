import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:letsch_do/src/screens/future_list.dart';
import 'package:letsch_do/src/screens/log_list.dart';
import 'package:letsch_do/src/screens/side_drawer.dart';
import 'package:letsch_do/src/screens/todo_list.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


// home skeleton class to have the bottom nav bar appearing on the app
class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // add bottom nav bar
  int _currentNavBarIndex = 1; // init first page appearing after app open to be TodoList screen

  // all pages must be insert into this list
  final List<Widget> _children = [
    LogList(),
    TodoList(),
    FutureList(),
  ];

  // 20201210 local notification [start]
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: onSelectNotification,
    );

    debugPrint('initState running');

    scheduleNotification();
  }

  Future onSelectNotification(String payload) {
    debugPrint('onSelectNotification - payload = ' + payload);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return NewScreen(
            payload: payload,
          );
        }
      )
    );

    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Home(title: 'Let\'sch Do!',),
    //   ),
    // );

    // Navigator.of(context).pop();
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Home(title: 'Let\'sch Do!',),
    //   ),
    // );
  }
  // 20201210 local notification [end]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Let\'sch Do'),
      ),

      drawer: SideDrawer(), // 20201209 add side drawer

      body: _children[_currentNavBarIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentNavBarIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'To-do Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fast_forward),
            label: 'Upcoming',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentNavBarIndex = index;
    });
  }

  Future<void> scheduleNotification() async {
    
    debugPrint('scheduleNotification running');

    // var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 10,));

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur'));

    // schedule date and time for notification
    var scheduledDateTime = tz.TZDateTime.local(DateTime.now().year, DateTime.now().month, DateTime.now().day+1, 7, 30);
    debugPrint("Scheduled date and time for notification = " + scheduledDateTime.toString());

    var androidPlatformChannelSpecific = AndroidNotificationDetails(
      'channelId',
      'channelName',
      'channelDescription',
    );

    var platformChannelSpecific = NotificationDetails(
      android: androidPlatformChannelSpecific,
    );

    debugPrint('await flutterLocalNotificationsPlugin.zonedSchedule start');
    // await flutterLocalNotificationsPlugin.schedule(id, title, body, scheduledDate, notificationDetails)
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, 
      'You have scheduled task(s) for today.', 
      'Tap the notification to see more.', 
      // scheduleNotificationDateTime, 
      // tz.TZDateTime.now(tz.local).add(Duration(seconds: 10,)),
      scheduledDateTime,
      platformChannelSpecific, 
      uiLocalNotificationDateInterpretation: null, 
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint('await flutterLocalNotificationsPlugin.zonedSchedule end');
  }

}

class NewScreen extends StatelessWidget {
  String payload;

  NewScreen({
    @required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications menu'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Hello!',
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            ),
          ],
        ),
    );
  }
}