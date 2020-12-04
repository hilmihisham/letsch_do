import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsch_do/src/models/todo.dart';
import 'package:letsch_do/src/screens/todo_detail.dart';
import 'package:letsch_do/src/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

// class FutureList extends StatelessWidget {
//   final Color color;

//   FutureList(this.color);

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

// class for Future List screen
class FutureList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FutureListState();
  }
}

class FutureListState extends State<FutureList> {
  
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> futureList;
  int count = 0;
  
  @override
  Widget build(BuildContext context) {
    
    if (futureList == null) {
      futureList = List<Todo>();
      updateListView();
    }

    if (futureList.length != 0) {
      return Scaffold(
        // appBar: AppBar(
        //   title: Text('Todo + SQL'),
        // ),
        body: getFutureListStaticView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('FAB clicked');
            navigateToDetail(Todo('', ''), 'Add Todo');
          },
          tooltip: 'Add Todo',
          child: Icon(Icons.add),
        ),
      );
    }
    else {
      debugPrint("Nothing's planned at the moment.");

      return Scaffold(
        // appBar: AppBar(
        //   title: Text('Todo + SQL'),
        // ),
        body: Center(
          child: Text("Nothing's planned at the moment."),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('FAB clicked');
            navigateToDetail(Todo('', ''), 'Add Todo');
          },
          tooltip: 'Add Todo',
          child: Icon(Icons.add),
        ),
      );
    }
  }

  ListView getFutureListStaticView() {

    List<int> dateTodoList = [];
    List<Widget> futureListGroupByDateDone = [];

    int futureListPointer = 0; // save pointer for quicker traversing

    // traverse logList to get all unique doneDate into dateDoneList
    for (int i = 0; i < futureList.length; i++) {
      if (!dateTodoList.contains(futureList.elementAt(i).dateTodo)) {
        dateTodoList.add(futureList.elementAt(i).dateTodo);
      }
    }

    // build column of listTile with date divider on top (grouping all list by date)
    for (int j = 0; j < dateTodoList.length; j++) {
      List<Widget> listGroup = [];

      // add date at the beginning of listGroup
      listGroup.add(
        Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0,),
          child: Text(
            DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(dateTodoList.elementAt(j))),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textScaleFactor: 1.2,
          ),
        ),
      );

      // add all logList with dateDone = dateDoneList[j]
      for (int k = futureListPointer; k < futureList.length; k++) {
        if (futureList.elementAt(k).dateTodo == dateTodoList.elementAt(j)) {
          listGroup.add(
            ListTile(
              leading: Icon(
                Icons.label_important_outline,
                color: Colors.orangeAccent,
                size: 32.0,
              ),
              title: Text(
                futureList.elementAt(k).title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'To do on ' + DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(futureList.elementAt(k).dateTodo)), // TODO: maybe use dateTodoList[j] later
                style: TextStyle( color: Colors.grey[600], ),
              ),
              tileColor: logTileColor(k),
              onTap: () {
                debugPrint("ListTile tapped");
                navigateToDetail(futureList.elementAt(k), 'Edit Todo');
              },
            ),
          );
        }
        else {
          futureListPointer = k; // save current pointer
          break; // exit k loop to create another date group
        }
      }

      futureListGroupByDateDone.addAll(listGroup);
    }
    
    return ListView(
      children: futureListGroupByDateDone,
    );
  }
  
  void navigateToDetail(Todo todo, String title) async {

    ScaffoldMessenger.of(context).removeCurrentSnackBar(); // 20201203 hero error fix

    bool result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) {
          return TodoDetail(todo, title);
        }
      )
    );

    debugPrint("navigateToDetail result = " + result.toString());

    if(result == true) {
      updateListView();
    }
  }
  
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      Future<List<Todo>> futureListFuture = databaseHelper.getFutureTodoList();
      futureListFuture.then((futureList) {
        setState(() {
          this.futureList = futureList;
          this.count = futureList.length;
        });
      });
    });
  }

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
}