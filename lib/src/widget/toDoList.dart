import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoList extends StatefulWidget {
  @override
  createState() => new ToDoListState();
}

class ToDoListState extends State<ToDoList> {
  
  // all to do items is in this string list
  List<String> _toDoItems = ["Nothing on the list yet!"];

  // This will be called each time the + button is pressed
  void _addToDoItems(String task) {
    // Putting our code inside "setState" tells the app that our state has changed, and it will automatically re-render the list
    // only add task if task is not empty
    if(task.length > 0) {
      setState(() => _toDoItems.add(task));
    }
  }

  // build the whole list of the todo items
  Widget _buildToDoList() {
    return new ListView.builder(
      // padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.

        if(index < _toDoItems.length) {
          return _buildToDoItem(_toDoItems[index], index);
        }
        
        return null;
        // print("index = " + index.toString());
        // print("_toDoItems.length = " + _toDoItems.length.toString());
        // return _buildToDoItem(_toDoItems[index], index);
      },
    );
  }

  // build a single todo item
  Widget _buildToDoItem(String toDoText, int index) {
    // return new ListTile(
    //   title: new Text(toDoText),
    //   onTap: () => _promptRemoveToDoItem(index),
    // );

    return new Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        // color: Color.fromARGB(255, 230, 224, 212),
        child: ListTile(
          title: new Text(toDoText),
          onTap: () => _promptRemoveToDoItem(index),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Mark Done',
          color: Colors.green,
          icon: Icons.check,
          onTap: () => _removeToDoItem(index),
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Mark Done',
          color: Colors.green,
          icon: Icons.check,
          onTap: () => _removeToDoItem(index),
        )
      ],
    );
  }

  void _pushAddToDoScreen() {
    // push this page onto the navi stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well as adding a back button to close it
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Add a new task'),
            ),
            body: new TextField(
              autofocus: true,
              onSubmitted: (val) {
                _addToDoItems(val);
                Navigator.pop(context); // close add todo screen
              },
              decoration: new InputDecoration(
                hintText: 'Enter task here...',
                contentPadding: const EdgeInsets.all(16.0),
              ),
            ),
          );
        }
      )
    );
  }

  // Much like _addTodoItem, this modifies the array of todo strings and notifies the app that the state has changed by using setState
  void _removeToDoItem(int index) {
    setState(() => _toDoItems.removeAt(index));
  }

  // Show an alert dialog asking the user to confirm that the task is done
  void _promptRemoveToDoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Mark "${_toDoItems[index]}" as done?'),
          actions: <Widget>[
            new FlatButton(
              padding: const EdgeInsets.all(16.0),
              child: new Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            new FlatButton(
              padding: const EdgeInsets.all(16.0),
              child: new Text('MARK AS DONE'),
              onPressed: () {
                _removeToDoItem(index);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Let\'sch Do!'),
      ),
      body: _buildToDoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddToDoScreen, // opens new screen to add
        tooltip: 'Add task',
        child: new Icon(Icons.add),
      ),
    );
  }

}