import 'package:flutter/material.dart';
import 'package:letsch_do/src/screens/future_list.dart';
import 'package:letsch_do/src/screens/log_list.dart';
import 'package:letsch_do/src/screens/todo_list.dart';

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
  final List<Widget> _pages = [
    LogList(),
    TodoList(),
    FutureList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Let\'sch Do'),
      ),
      body: Center(
        child: _buildScreens(),
      ),

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

  Stack _buildScreens() {
    List<Widget> children = [];
    _pages.asMap().forEach((index, value) {
      children.add(
        Offstage(
          offstage: _currentNavBarIndex != index,
          child: TickerMode(
            enabled: _currentNavBarIndex == index,
            child: value,
          ),
        ),
      );
    });

    return Stack( children: children, );
  }
}