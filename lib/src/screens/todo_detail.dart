import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsch_do/src/models/todo.dart';
import 'package:letsch_do/src/utils/database_helper.dart';

// class for Add/Edit Todo screen
class TodoDetail extends StatefulWidget {
  final String appBarTitle;
  final Todo todo;

  TodoDetail( this.todo, this.appBarTitle );

  @override
  State<StatefulWidget> createState() {
    return TodoDetailState(this.todo, this.appBarTitle);
  }
}

class TodoDetailState extends State<TodoDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Todo todo;

  TextEditingController titleController = TextEditingController();

  TodoDetailState( this.todo, this.appBarTitle );

  // 20201202 add date picker for dateTodo [start]
  DateTime todoDateChosen = DateTime.now(); // int to be today

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      todoDateChosen = order;
    });
  }

  Future<DateTime> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add( Duration( days: 365, ) ),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      }
    );
  }
  // 20201202 date picker [end]

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    titleController.text = todo.title;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0,),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0,),
                child: TextField(
                  autofocus: true, // 20201201 autofocus to this text field when screen appear
                  maxLength: 255, // 20201201 add length limit (+ char counter)
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in title text field');
                    updateTitle();
                  },
                  // 20201201 - click save when hitting enter key [start]
                  onSubmitted: (value) {
                    if (value.length != 0) {
                      debugPrint('value = ' + value);
                      debugPrint('Enter key pressed');
                      _save();
                    }
                    else {
                      debugPrint('value = ' + value);
                      debugPrint('value.length = ' + value.length.toString());

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in the task before saving.'),
                        )
                      );
                    }
                  },
                  // 20201201 [end]
                  decoration: InputDecoration(
                    labelText: 'Task', // 20201201 edit 'Title' to 'Task'
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

              // 20201202 add date picker for dateTodo [start]
              // Padding(
              //   padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0,),
              //   child: Text(
              //     'To do on ' + DateFormat.yMMMd().format(todoDateChosen),
              //     style: Theme.of(context).textTheme.headline6,
              //     // textScaleFactor: 2.0,
              //   ),
              // ),

              // Padding(
              //   padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
              //   child: Row(
              //     children: <Widget>[
              //       RaisedButton(
              //         color: Colors.blueAccent,
              //         textColor: Colors.white,
              //         child: Text(
              //           'Select date to do this task',
              //           // textScaleFactor: 1.5,
              //         ),
              //         onPressed: callDatePicker,
              //       ),
              //     ],
              //   ),
              // ),

              Padding(
                padding: EdgeInsets.only(top: 2.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'To do on ' + DateFormat.yMMMd().format(todoDateChosen),
                        style: Theme.of(context).textTheme.headline6,
                        // textScaleFactor: 2.0,
                      ),
                    ),

                    Container(width: 5.0,),

                    RaisedButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        'Select date',
                        // style: Theme.of(context).textTheme.headline6,
                        textScaleFactor: 1.3,
                      ),
                      onPressed: callDatePicker,
                    ),
                  ],
                ),
              ),
              // 20201202 date picker [end]

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save button clicked");
                            _save();
                          });
                        },
                      ),
                    ),

                    Container(width: 5.0,),

                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void _save() async {
    
    moveToLastScreen();

    todo.date = DateFormat.yMMMd().add_Hms().format(DateTime.now());
    debugPrint('todo.date = ' + todo.date);

    todo.done = "0";

    todo.dateCreated = DateTime.now().millisecondsSinceEpoch.toInt();

    int result;

    if(todo.id != null) {
      // case 1 - update operation
      result = await helper.updateTodo(todo);
    }
    else {
      // case 2 - insert operation
      result = await helper.insertTodo(todo);
    }

    if(result != 0) {
      // success
      _showAlertDialog('Status', 'Todo saved successfully!');
    }
    else {
      _showAlertDialog('Status', 'Problem Saving Todo');
    }
  }

  void _delete() async {
    moveToLastScreen();

		// Case 1: If user is trying to delete the NEW todo i.e. he has come to
		// the detail page by pressing the FAB of todoList page.
		if (todo.id == null) {
			_showAlertDialog('Status', 'No Todo was deleted');
			return;
		}

		// Case 2: User is trying to delete the old todo that already has a valid ID.
		int result = await helper.deleteTodo(todo.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Todo Deleted Successfully');
		} else {
			_showAlertDialog('Status', 'Error Occured while Deleting Todo');
		}
  }

  void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}
}