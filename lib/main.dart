import 'package:flutter/material.dart';
import 'package:letsch_do/home.dart';
// import 'package:letsch_do/src/screens/todo_list.dart';

// import 'package:letsch_do/src/widget/reorderableList.dart';
// import 'src/widget/toDoList.dart';
// import 'src/widget/dismissibleList.dart';
// import 'src/widget/slidableList.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".
void main() => runApp(new LetschDoApp());

// Every component in Flutter is a widget, even the whole app itself
class LetschDoApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Let\'sch Do!',
      // home: new ToDoList(),
      // home: new DismissibleList(),
      // home: new SlidableList(),
      // home: new ReorderableList(),
      // home: TodoList(),
      home: Home(title: 'Let\'sch Do!',),
      theme: new ThemeData(
        primaryColor: Colors.red[900],
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Color.fromARGB(255, 230, 224, 212),
        
        // brightness: Brightness.dark,
        
        // primarySwatch: Colors.red,
        // scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}