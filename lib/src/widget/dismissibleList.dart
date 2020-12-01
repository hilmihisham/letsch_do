import 'package:flutter/material.dart';

class DismissibleList extends StatefulWidget {
  @override
  createState() => new DismissibleListState();
}

class DismissibleListState extends State<DismissibleList> {
  final items = List<String>.generate(25, (index) => "Item n° ${index + 1}");

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: "Dismissing Items",
      theme: new ThemeData(
        primaryColor: Colors.red[900],
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Color.fromARGB(255, 230, 224, 212),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Let'sch Dismiss Swipe"),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {

                if(direction == DismissDirection.startToEnd) {
                  // remove swiped items
                  setState(() {
                    items.removeAt(index);
                  });
                  
                  // show snackbar for dismiss message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$item has been dismissed."),
                    ),
                  );
                }
                else {
                  // remove swiped items
                  setState(() {
                    items.removeAt(index);
                  });

                  // show snackbar for dismiss message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$item has been dismissed from end to start."),
                    ),
                  );
                }
                
              },
              background: Container( color: Colors.teal, ),
              child: ListTile( title: Text("$item"), ),
            );
          },
        ),
      ),
    );
  }
  
}