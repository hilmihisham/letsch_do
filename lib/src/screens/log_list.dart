import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:letsch_do/src/models/todo.dart';
import 'package:letsch_do/src/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

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
      // appBar: AppBar(
      //   title: Text('Todo + SQL'),
      // ),
      // body: getLogListView(),
      // body: getLogListStaticView(), // 20201204 static ListView
      body: getGroupedLogListView(), // 20201209 GroupedListView
    );
  }

  // 20201204 create a static ListView for logList [start]
  ListView getLogListStaticView() {

    List<int> dateDoneList = [];
    List<Widget> logListGroupByDateDone = [];

    int logListPointer = 0; // save pointer for quicker traversing

    // traverse logList to get all unique doneDate into dateDoneList
    for (int i = 0; i < logList.length; i++) {
      if (!dateDoneList.contains(logList.elementAt(i).dateDone)) {
        dateDoneList.add(logList.elementAt(i).dateDone);
      }
    }

    // build column of listTile with date divider on top (grouping all list by date)
    for (int j = 0; j < dateDoneList.length; j++) {
      List<Widget> listGroup = [];

      // add date at the beginning of listGroup
      listGroup.add(
        Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0,),
          child: Text(
            DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(dateDoneList.elementAt(j))),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textScaleFactor: 1.2,
          ),
        ),
      );

      // add all logList with dateDone = dateDoneList[j]
      for (int k = logListPointer; k < logList.length; k++) {
        if (logList.elementAt(k).dateDone == dateDoneList.elementAt(j)) {
          listGroup.add(
            ListTile(
              leading: Icon(
                Icons.label_important_outline,
                color: Colors.lightGreen[900],
                size: 32.0,
              ),
              title: Text(
                logList.elementAt(k).title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              subtitle: Text(
                // 20201202 change date to show [start]
                // this.logList[position].date,
                'Finished ' + DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(logList.elementAt(k).dateDone)),
                // 20201202 change date [end]
                style: TextStyle( color: Colors.grey[600], ),
              ),
              tileColor: logTileColor(k),
            ),
          );
        }
        else {
          logListPointer = k; // save current pointer
          break; // exit k loop to create another date group
        }
      }

      logListGroupByDateDone.addAll(listGroup);
    }
    
    return ListView(
      children: logListGroupByDateDone,
    );
  }
  // 20201204 static ListView [end]

  // 20201209 using GroupedListView widget for logList [start]
  GroupedListView getGroupedLogListView() {
    return GroupedListView<dynamic, int>(
      elements: logList,
      groupBy: (todo) {
        return todo.dateDone;
      },
      groupSeparatorBuilder: (int dateDone) => Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0,),
        child: Text(
          DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(dateDone)),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textScaleFactor: 1.2,
        ),
      ),
      order: GroupedListOrder.DESC,
      itemBuilder: (BuildContext context, dynamic todo) => ListTile(
        leading: Icon(
          Icons.label_important_outline,
          color: Colors.lightGreen[900],
          size: 32.0,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          // 20201202 change date to show [start]
          // this.logList[position].date,
          'Finished ' + DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(todo.dateDone)),
          // 20201202 change date [end]
          style: TextStyle( color: Colors.grey[600], ),
        ),
        tileColor: logTileColor(logList.indexOf(todo)),
      ),
    );
  }
  // 20201209 GroupedListView [end]

  // ListView getLogListView() {
  //   return ListView.builder(
  //     itemCount: count,
  //     itemBuilder: (BuildContext context, int position) {
  //       // 20201202 - change visual for log list [start]
  //       // 20201203 adding date done divider [start]
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[

  //           uniqueDateDoneDivider(this.logList[position]), // 20201203 for use of date divider
            
  //           ListTile(
  //             leading: Icon(
  //               Icons.label_important_outline,
  //               color: Colors.lightGreen[900],
  //               size: 32.0,
  //             ),
  //             title: Text(
  //               this.logList[position].title,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.grey[600],
  //               ),
  //             ),
  //             subtitle: Text(
  //               // 20201202 change date to show [start]
  //               // this.logList[position].date,
  //               'Finished ' + DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(this.logList[position].dateDone)),
  //               // 20201202 change date [end]
  //               style: TextStyle( color: Colors.grey[600], ),
  //             ),
  //             tileColor: logTileColor(position),
  //           ),

  //         ],
  //       );
  //       // 20201203 divider [end]
  //       // 20201202 - change visual [end]
  //     },
  //   );
  // }

  // 20201203 padding for dateDone divider [start]
  // Padding uniqueDateDoneDivider(Todo currentTodo) {

  //   // dateDone in question
  //   String dateDone = DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(currentTodo.dateDone));
  //   debugPrint("dateDone = " + dateDone);

  //   // if dateDone not yet in unique list
  //   if (!dateDoneUnique.contains(dateDone)) {
      
  //     // add unique dateDone to list
  //     dateDoneUnique.add(dateDone);

  //     // create divider visuals
  //     return Padding(
  //       padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0,),
  //       child: Text(
  //         dateDone,
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //         ),
  //         textScaleFactor: 1.2,
  //       ),
  //     );
  //   }
  //   else {
  //     return Padding(
  //       padding: EdgeInsets.zero,
  //     );
  //   }
    
  // }
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