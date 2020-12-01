import 'package:flutter/material.dart';

class StrikethroughText extends StatelessWidget {
  
  bool todoToggle;
  String todoText;
  StrikethroughText({ this.todoToggle, this.todoText }) : super();

  Widget _strikeWidget() {
    if(todoToggle == false) {
      return Text(
        todoText,
        style: TextStyle(
          fontSize: 22.0,
        ),
      );
    }
    else {
      return Text(
        todoText,
        style: TextStyle(
          fontSize: 22.0,
          decoration: TextDecoration.lineThrough,
          color: Colors.red,
          fontStyle: FontStyle.italic,  
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return _strikeWidget();
  }

}