import 'package:flutter/material.dart';
import 'package:letsch_do/src/screens/about_page.dart';

// class for side drawer widget
class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Let\'sch Do',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.red[900],
            ),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            onTap: () => {
              
              // dismiss the side drawer
              Navigator.of(context).pop(), 

              // push about page to navigator
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => AboutPage()
              )),
            },
          )
        ],
      ),
    );
  }
}