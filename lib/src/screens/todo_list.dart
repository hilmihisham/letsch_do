import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsch_do/src/models/todo.dart';
import 'package:letsch_do/src/screens/todo_detail.dart';
import 'package:letsch_do/src/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

// class for Todo List screen
class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }

    if (todoList.length != 0) {
      return Scaffold(
        // appBar: AppBar(
        //   title: Text('Todo + SQL'),
        // ),
        body: getTodoListView(),
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
      debugPrint("Todo List empty");
      // return Center(
      //   child: Text('Todo List empty'),
      // );
      return Scaffold(
        // appBar: AppBar(
        //   title: Text('Todo + SQL'),
        // ),
        body: Center(
          child: Text('Todo List empty'),
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

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Todo + SQL'),
    //   ),
    //   body: getTodoListView(),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       debugPrint('FAB clicked');
    //       navigateToDetail(Todo('', ''), 'Add Todo');
    //     },
    //     tooltip: 'Add Todo',
    //     child: Icon(Icons.add),
    //   ),
    // );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {

        //20201202 change visual to dismissible [start]
        final todoItem = todoList.elementAt(position); // init each item in todo list here

        return Dismissible(
          // key: ValueKey(todoItem),
          // key: Key(todoItem.id.toString()),
          key: UniqueKey(),
          child: ListTile(
            // 20201201 change leading to icons [start]
            // leading: CircleAvatar(
            //   backgroundColor: Colors.orange[900],
            //   child: Text(
            //     getFirstLetter(this.todoList[position].title),
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            leading: Icon(
              Icons.label_important,
              color: Colors.orangeAccent,
              size: 32.0,
            ),
            // 20201201 [end]
            title: Text(
              todoItem.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              // 20201202 change date to show [start]
              //todoItem.date,
              // 'Added ' + DateFormat.yMMMd().add_Hms().format(DateTime.fromMillisecondsSinceEpoch(todoItem.dateCreated)),
              'To do on ' + DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(todoItem.dateTodo)),
              // 20201202 change date [end]
            ),
            // trailing: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            //     // GestureDetector(
            //     //   child: Icon(
            //     //     Icons.delete, 
            //     //     color: Colors.red,
            //     //   ),
            //     //   onTap: () {
            //     //     _delete(context, todoList[position]);
            //     //   },
            //     // ),
            //     GestureDetector(
            //       child: Icon(
            //         Icons.done, 
            //         color: Colors.green,
            //       ),
            //       onTap: () {
            //         _done(context, todoList[position]);
            //       },
            //     ),
            //   ],
            // ),
            onTap: () {
              debugPrint("ListTile tapped");
              navigateToDetail(todoItem, 'Edit Todo');
            },
          ),
          // 20201203 change onDismissed to confirmDismiss [start]
          // onDismissed: (direction) {
          //   // remove dismissed item from list first
          //   todoList.removeAt(position);

          //   // action to be taken after swipe action
          //   if (direction == DismissDirection.startToEnd) {
          //     _done(context, todoItem);
          //   }
          //   else {
          //     _delete(context, todoItem); // temp method to change to _delete
          //   }
          // },
          confirmDismiss: (direction) async {

            // todoList.removeAt(position);
            for (var item in todoList) {
              debugPrint('item in tree before = ' + item.title);
              debugPrint('item id before      = ' + item.id.toString());
            }

            todoList.remove(todoItem);

            for (var item in todoList) {
              debugPrint('item in tree after = ' + item.title);
              debugPrint('item id after      = ' + item.id.toString());
            }

            debugPrint('-------------------------------------------------');

            if (direction == DismissDirection.startToEnd) {
              _done(context, todoItem);
              return true;
            }
            else if (direction == DismissDirection.endToStart) {
              _delete(context, todoItem);
              return true;
            }
            else {
              return false;
            }
          },
          // 20201203 confirmDismissed [end]
          background: Container(
            // swipe to right bg
            color: Colors.green,
            padding: EdgeInsets.symmetric( horizontal: 20, ),
            alignment: AlignmentDirectional.centerStart,
            child: Icon(
              Icons.done,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            // swipe to left bg
            color: Colors.red, 
            padding: EdgeInsets.symmetric( horizontal: 20, ),
            alignment: AlignmentDirectional.centerEnd,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        );

        // return Card(
        //   color: Colors.white,
        //   elevation: 2.0,
        //   child: ListTile(
        //     // 20201201 change leading to icons [start]
        //     // leading: CircleAvatar(
        //     //   backgroundColor: Colors.orange[900],
        //     //   child: Text(
        //     //     getFirstLetter(this.todoList[position].title),
        //     //     style: TextStyle(
        //     //       fontWeight: FontWeight.bold,
        //     //     ),
        //     //   ),
        //     // ),
        //     leading: Icon(
        //       Icons.label_important,
        //       color: Colors.orangeAccent,
        //       size: 32.0,
        //     ),
        //     // 20201201 [end]
        //     title: Text(
        //       this.todoList[position].title,
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     subtitle: Text(
        //       this.todoList[position].date,
        //     ),
        //     trailing: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: <Widget>[
        //         // GestureDetector(
        //         //   child: Icon(
        //         //     Icons.delete, 
        //         //     color: Colors.red,
        //         //   ),
        //         //   onTap: () {
        //         //     _delete(context, todoList[position]);
        //         //   },
        //         // ),
        //         GestureDetector(
        //           child: Icon(
        //             Icons.done, 
        //             color: Colors.green,
        //           ),
        //           onTap: () {
        //             _done(context, todoList[position]);
        //           },
        //         ),
        //       ],
        //     ),
        //     onTap: () {
        //       debugPrint("ListTile tapped");
        //       navigateToDetail(this.todoList[position], 'Edit Todo');
        //     },
        //   ),
        // );
        // 20201202 dismissible [end]
      },
    );
  }

  // 20201201 unused, leading object change to icon [start]
  // getFirstLetter(String title) {
  //   return title.substring(0, 2);
  // }
  // 20201201 [end]

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if(result != 0) {
      debugPrint('delete ok!');
      _showSnackBar(context, 'Task deleted.');
      // updateListView();
    }
  }

  // added done button
  void _done(BuildContext context, Todo todo) async {
    int result = await databaseHelper.updateDoneTodo(todo);
    if (result != 0) {
      _showSnackBar(context, 'Task is done. Good job!');
      // updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    // Scaffold.of(context).showSnackBar(snackBar); // deprecated
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}

