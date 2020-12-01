import 'package:flutter/material.dart';
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
        return Card(
          color: Colors.white30,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                getFirstLetter(this.logList[position].title),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              this.logList[position].title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              this.logList[position].date,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.done,
                  color: Colors.lightGreen[900],
                )
                // GestureDetector(
                //   child: Icon(
                //     Icons.delete, 
                //     color: Colors.red,
                //   ),
                //   onTap: () {
                //     _delete(context, todoList[position]);
                //   },
                // ),
              ],
            ),
            // onTap: () {
            //   debugPrint("ListTile tapped");
            //   navigateToDetail(this.todoList[position], 'Edit Todo');
            // },
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
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
}