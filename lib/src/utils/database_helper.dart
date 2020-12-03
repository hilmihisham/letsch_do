import 'dart:io';

import 'package:flutter/material.dart';
import 'package:letsch_do/src/models/todo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
	static Database _database;                // Singleton Database

  // list of column name in table 'todo_table'
  String todoTable = 'todo_table';

  String colId = 'id';
	String colTitle = 'title';
	String colDate = 'date';
  String colDone = 'done'; // data should be '0' (in progress) and '1' (done)
  String colDateCreated = 'dateCreated';
  String colDateDone = 'dateDone';
  String colDateTodo = 'dateTodo';
  // list of column name in table 'todo_table'
  

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }

    return _databaseHelper;
  }

  // create the database object and provide it with a getter where we will instantiate the database if it’s not (lazy initialization)
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  // If there is no object assigned to the database, we use initializeDatabase function to create the database.
  // get the path for storing the database and create the desired tables.
  // db name = todos
  Future<Database> initializeDatabase() async {
    
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todos.db';
    debugPrint('path = ' + path);

    // Open/create the database at a given path
    var todosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $todoTable(' +
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT, ' +
        '$colTitle TEXT, ' +
        '$colDate TEXT, ' +
        '$colDone TEXT, ' +
        '$colDateCreated INTEGER, ' +
        '$colDateDone INTEGER,' + // 20201202 add column dateDone
        '$colDateTodo INTEGER' // 20201203 add column dateTodo
      ')'
    );
  }

  // Fetch Operation: Get all todo objects from database
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.database;

    // var result = await db.query(todoTable, orderBy: '$colTitle ASC');
    var result = await db.query(todoTable, where: '$colDone = ?', whereArgs: ['0'], orderBy: '$colTitle ASC'); // update to only get done = 0
    return result;
  }

  // fetch: get all done todo from db
  Future<List<Map<String, dynamic>>> getLogMapList() async {
    Database db = await this.database;

    var result = await db.query(todoTable, where: '$colDone = ?', whereArgs: ['1'], orderBy: '$colDateCreated DESC');
    return result;
  }

  // Insert Operation: Insert a todo object to database
  Future<int> insertTodo(Todo todo) async {
    Database db = await this.database;
    var result = await db.insert(todoTable, todo.toMap());
    return result;
  }

  // Update Operation: Update a todo object and save it to database
  Future<int> updateTodo(Todo todo) async {
    var db = await this.database;
    var result = await db.update(todoTable, todo.toMap(), where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }

  // Future<int> updateTodoCompleted(Todo todo) async {
  //   var db = await this.database;
  //   var result = await db.update(todoTable, todo.toMap(), where: '$colId = ?', whereArgs: [todo.id]);
  //   return result;
  // }

  // Delete Operation: Delete a todo object from database
  Future<int> deleteTodo(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $todoTable WHERE $colId = $id');
    return result;
  }

  // update : set todo to done
  Future<int> updateDoneTodo(Todo todo) async {
    var db = await this.database;

    // 20201202 added done date [start]
    int doneDate = DateTime.now().millisecondsSinceEpoch;
    debugPrint("doneDate = " + doneDate.toString());

    // int result = await db.update(todoTable, todo.updateDoneToMap('1'), where: '$colId = ?', whereArgs: [todo.id]);
    int result = await db.update(todoTable, todo.updateDoneToMap('1', DateTime.now().millisecondsSinceEpoch), where: '$colId = ?', whereArgs: [todo.id]);
    // 20201202 done date [end]

    return result;
  }

  // Get number of todo objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $todoTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'todo List' [ List<Todo> ]
  Future<List<Todo>> getTodoList() async {
    
    var todoMapList = await getTodoMapList(); // get 'Map List' from database
    int count = todoMapList.length; // count the number of map entries in db table

    List<Todo> todoList = List<Todo>();

    // creating todoList from MapList
    for (int i = 0; i < count; i++) {
      todoList.add(Todo.fromMapObject(todoMapList[i]));
    }

    return todoList;
  }

  // getting log list
  Future<List<Todo>> getLogList() async {

    var logMapList = await getLogMapList();
    int count = logMapList.length;

    List<Todo> logList = List<Todo>();

    for (int i = 0; i < count; i++) {
      logList.add(Todo.fromMapObject(logMapList[i]));
    }

    return logList;
  }
  
}