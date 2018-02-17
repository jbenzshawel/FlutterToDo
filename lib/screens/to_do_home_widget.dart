import 'package:flutter/material.dart';
import '../shared/to_do_list.dart';

class ToDoItemWidget extends StatelessWidget {
  final ToDoList toDoItem;

  ToDoItemWidget({Key key, toDoItem}) 
    : toDoItem = toDoItem,
      super(key: new ObjectKey(toDoItem));

  void _handleShowToDoList(BuildContext context) {
    Navigator.pushNamed(context, '/list:${toDoItem.id}');
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new ListTile(
            title: new Text(toDoItem.title),
            onTap: () {
              _handleShowToDoList(context);
            }
          )
        )  
      ]);
  }
}

class ToDoHomeWidget extends StatefulWidget {

  final List<ToDoList> toDoItems;
    
  ToDoHomeWidget({Key key, this.toDoItems}) : super(key: key);

  @override
  _ToDoHomeState createState() => new _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHomeWidget> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("To Do Lists"),
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: widget.toDoItems.map((ToDoList toDoItem) {
          return new ToDoItemWidget(
            toDoItem: toDoItem
          );
        }).toList(),
      )
    );
  }
}
