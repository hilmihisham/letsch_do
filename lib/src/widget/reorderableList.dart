import 'package:flutter/material.dart';
import 'package:letsch_do/src/widget/strikethroughText.dart';

class ReorderableList extends StatefulWidget {
  @override
  _ReorderableListState createState() => _ReorderableListState();
}

List<String> items = ["Test Item 1", "Item n° 2", "#3 Item", "Item ke-4", "5th Object"];
bool toggle = false;

class _ReorderableListState extends State<ReorderableList> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let\'sch Reorder List"),
      ),
      body: ReorderableListView(
        children: <Widget>[
          for(final value in items)
            CheckboxListTile(
              key: Key(value),
              value: toggle,
              onChanged: (bool) {
                setState(() {
                  if (!bool) {
                    toggle = false;
                  } 
                  else {
                    toggle = true;
                  }
                });
              },
              // leading: Icon(Icons.sort),
              title: StrikethroughText(
                todoText: value,
                todoToggle: toggle,
              ),
              // title: Text(
              //   value,
              //   key: Key(value),
              //   style: TextStyle(
              //     fontSize: 22.0,
              //   ),
              // ),
              subtitle: Text("Today"),
            )
        ],
        onReorder: (int oldIndex, int newIndex) {
          print("1 oldIndex = " + oldIndex.toString());
          print("1 newIndex = " + newIndex.toString());

          setState(() {
            if(oldIndex < newIndex) {
              newIndex -= 1;
            }

            print("2 oldIndex = " + oldIndex.toString());
            print("2 newIndex = " + newIndex.toString());

            var getReplacedWidget = items.removeAt(oldIndex);
            items.insert(newIndex, getReplacedWidget);
          });
        },
      ),
    );
  }
}