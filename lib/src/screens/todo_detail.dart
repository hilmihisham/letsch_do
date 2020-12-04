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
  DateTime dateTodayInit = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day); // today's date at 0000hrs, for showDatePicker use
  DateTime todoDateChosen; // = DateTime.now(); // int to be today

  Future<void> _selectDate(BuildContext context) async {

    debugPrint("dateTodayInit = " + dateTodayInit.toString());

    final DateTime datePicked = await showDatePicker(
      context: context,
      initialDate: todoDateChosen,
      firstDate: dateTodayInit,
      lastDate: DateTime.now().add( Duration( days: 365*3, ) ),
      helpText: 'SELECT TASK DATE',
      errorInvalidText: 'Calm down, you\'re planning too far ahead.',
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      }
    );

    if (datePicked != null && datePicked != todoDateChosen) {
      debugPrint("datePicked = " + datePicked.toString());

      setState(() {
        todoDateChosen = datePicked;
      });
    }
  }
  // 20201202 date picker [end]

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    titleController.text = todo.title;
    
    // 20201204 fix todoDateChosen always init to today for "Add Todo" screen [start]
    if (appBarTitle.startsWith("E") && todoDateChosen == null) {
      // for "Edit Todo" screen, init from existing dateTodo
      todoDateChosen = DateTime.fromMillisecondsSinceEpoch(this.todo.dateTodo);
      debugPrint("existing dateTodo = " + todoDateChosen.toString());
    }
    else {
      if (todoDateChosen == null) {
        // "Add Todo" screen, first time open
        todoDateChosen = DateTime.now();
        debugPrint("init todoDateChosen = " + todoDateChosen.toString());
      }
      else {
        // date already chosen from calendar, do nothing
        debugPrint("from cal todoDateChosen = " + todoDateChosen.toString());
      }
    }
    // if (this.todo.dateTodo == null) {
    //   todoDateChosen = DateTime.now();
    //   debugPrint("init todoDateChosen = " + todoDateChosen.toString());
    // }
    // else {
    //   if (todoDateChosen == null) {
    //     todoDateChosen = DateTime.fromMillisecondsSinceEpoch(this.todo.dateTodo);
    //     debugPrint("prev todoDateChosen = " + todoDateChosen.toString());
    //   }
    //   else {
    //     debugPrint("from cal todoDateChosen = " + todoDateChosen.toString());
    //   }
    // }
    // 20201204 fix todoDateChosen [end]

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
                  maxLines: null, // 20201203 expands text field for multi-line input
                  textInputAction: TextInputAction.done, // 20201203 enter key trigger onSubmitted
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    // debugPrint('Something changed in title text field');
                    updateTitle();
                  },
                  // 20201201 - click save when hitting enter key [start]
                  onSubmitted: (value) {
                    _save();
                  },
                  // 20201201 enter save [end]
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
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
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
                        textScaleFactor: 1.3,
                      ),
                      onPressed: () => _selectDate(context),
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
                        textColor: Colors.white, //Theme.of(context).primaryColorLight,
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
                        textColor: Colors.white, //Theme.of(context).primaryColorLight,
                        // child: Text(
                        //   'Delete',
                        //   textScaleFactor: 1.5,
                        // ),
                        child: cancelOrDeleteButton(),
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

  Text cancelOrDeleteButton() {
    if (appBarTitle.startsWith('A')) {
      // title: Add Todo
      debugPrint('appBarTitle = ' + appBarTitle);
      return Text(
        'Cancel',
        textScaleFactor: 1.5,
      );
    }
    else {
      // title: Edit Todo
      debugPrint('appBarTitle = ' + appBarTitle);
      debugPrint('here');
      return Text(
        'Delete',
        textScaleFactor: 1.5,
      );
    }
  }

  void moveToLastScreen() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar(); // 20201203 hero error fix
		Navigator.pop(context, true);
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void _save() async {
    
    // 20201203 fix to prevent save button saving task with empty title [start]
    if (todo.title.length != 0) {
      moveToLastScreen();

      todo.date = DateFormat.yMMMd().add_Hms().format(DateTime.now());
      debugPrint('todo.date = ' + todo.date);

      todo.done = "0";

      todo.dateCreated = DateTime.now().millisecondsSinceEpoch.toInt();
      debugPrint("dateCreated = " + todo.dateCreated.toString());

      // 20201204 clean time data to 0000hrs for dateTodo [start]
      // todo.dateTodo = todoDateChosen.millisecondsSinceEpoch;
      todo.dateTodo = DateTime(todoDateChosen.year, todoDateChosen.month, todoDateChosen.day).millisecondsSinceEpoch;
      // 20201204 clean dateTodo [end]
      debugPrint("dateTodo = " + todo.dateTodo.toString());
      debugPrint("dateTodo = " + DateFormat.yMMMd().add_Hms().format(DateTime.fromMillisecondsSinceEpoch(todo.dateTodo)));

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
        // _showAlertDialog('Status', 'Todo saved successfully!');
        if (appBarTitle.startsWith('A')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New task created!'),
            )
          );
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task updated.'),
            )
          );
        }
      }
      else {
        _showAlertDialog('Error!', 'Problem Saving New Task');
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in the task before saving.'),
        )
      );
    }
    // 20201203 empty title fix [end]
  }

  void _delete() async {
    moveToLastScreen();

		// Case 1: If user is trying to delete the NEW todo i.e. he has come to
		// the detail page by pressing the FAB of todoList page.
		if (todo.id == null) {
			// _showAlertDialog('Status', 'No Todo was deleted');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('New task is not created.'),
      //   )
      // );
			return;
		}

		// Case 2: User is trying to delete the old todo that already has a valid ID.
		int result = await helper.deleteTodo(todo.id);
		if (result != 0) {
			// _showAlertDialog('Status', 'Task Deleted Successfully');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task deleted.'),
          )
        );
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