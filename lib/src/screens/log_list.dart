import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsch_do/src/models/todo.dart';
import 'package:letsch_do/src/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

// class LogList extends StatelessWidget {
//   final Color color;

//   LogList(this.color);

//   @override
//   Widget build(BuildContext context) {
//     //  return Container(
//     //    color: color,
//     //  );
//     return Scaffold(
//       appBar: AppBar(
//           title: Text('Todo + SQL'),
//         ),
//         body: Container(
//           color: color,
//         )
//     );
//   }
// }

// class for Log List screen
// all todo item that have been marked done will be appearing here
class LogList extends StatefulWidget {
  @override
  LogListState createState() => LogListState();
}

class LogListState extends State<LogList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> logList;
  int count = 0;

  List<String> dateDoneUnique = []; // 20201203 for use of date divider

  @override
  Widget build(BuildContext context) {
    
    if(logList == null) {
      logList = List<Todo>();
      updateLogListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo + SQL'),
      ),
      body: getLogListView(),
    );
  }

  ListView getLogListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        // 20201202 - change visual for log list [start]
        // 20201203 adding date done divider [start]
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            uniqueDateDoneDivider(this.logList[position]), // 20201203 for use of date divider
            
            ListTile(
              leading: Icon(
                Icons.label_important_outline,
                color: Colors.lightGreen[900],
                size: 32.0,
              ),
              title: Text(
                this.logList[position].title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              subtitle: Text(
                // 20201202 change date to show [start]
                // this.logList[position].date,
                'Finished ' + DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(this.logList[position].dateDone)),
                // 20201202 change date [end]
                style: TextStyle( color: Colors.grey[600], ),
              ),
              tileColor: logTileColor(position),
            ),

          ],
        );
        // 20201203 divider [end]
        // 20201202 - change visual [end]
      },
    );
  }

  // 20201203 padding for dateDone divider [start]
  Padding uniqueDateDoneDivider(Todo currentTodo) {

    // dateDone in question
    String dateDone = DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(currentTodo.dateDone));
    debugPrint("dateDone = " + dateDone);

    // if dateDone not yet in unique list
    if (!dateDoneUnique.contains(dateDone)) {
      
      // add unique dateDone to list
      dateDoneUnique.add(dateDone);

      // create divider visuals
      return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0,),
        child: Text(
          dateDone,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textScaleFactor: 1.2,
        ),
      );
    }
    else {
      return Padding(
        padding: EdgeInsets.zero,
      );
    }
    
  }
  // 20201203 dateDone divider [end]

  void updateLogListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      Future<List<Todo>> logListFuture = databaseHelper.getLogList();
      logListFuture.then((logList) {
        setState(() {
          this.logList = logList;
          this.count = logList.length;
        });
      });
    });
  }

  // 20201202 - differentiate tile color by odd and even lines [start]
  logTileColor(int position) {
    Color color;
    if (position % 2 == 0) {
      color = Colors.white24;
    }
    else {
      color = Colors.white54;
    }

    return color;
  }
  // 20201202 tile color [end]
}