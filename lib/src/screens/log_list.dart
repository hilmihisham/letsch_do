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
        return ListTile(
          leading: Icon(
            Icons.label_important_outline,
            color: Colors.lightGreen[900],
            size: 32.0,
          ),
          title: Text(
            this.logList[position].title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            // 20201202 change date to show [start]
            // this.logList[position].date,
            'Finished ' + DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(this.logList[position].dateDone)),
            // 20201202 change date [end]
          ),
          tileColor: logTileColor(position),
        );

        // return Card(
        //   color: Colors.white30,
        //   elevation: 2.0,
        //   child: ListTile(
        //     // 20201201 change leading to icons [start]
        //     // leading: CircleAvatar(
        //     //   backgroundColor: Colors.black,
        //     //   child: Text(
        //     //     getFirstLetter(this.logList[position].title),
        //     //     style: TextStyle(
        //     //       fontWeight: FontWeight.bold,
        //     //     ),
        //     //   ),
        //     // ),
        //     leading: Icon(
        //       Icons.label_important_outline,
        //       color: Colors.lightGreen[900],
        //       size: 32.0,
        //     ),
        //     // 20201201 [end]
        //     title: Text(
        //       this.logList[position].title,
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     subtitle: Text(
        //       this.logList[position].date,
        //     ),
        //     trailing: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: <Widget>[
        //         Icon(
        //           Icons.done,
        //           color: Colors.lightGreen[900],
        //         )
        //       ],
        //     ),
        //   ),
        // );
        // 20201202 - change visual [end]
      },
    );
  }

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