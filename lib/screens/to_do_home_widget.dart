import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../shared/to_do_list.dart';
import '../shared/widget_helper.dart';
import '../shared/storage.dart';

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
            title: new Text(
                toDoItem.title,
                style: new TextStyle (color: Colors.blue.shade300)
            ),
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
  final Storage storage;


  ToDoHomeWidget({Key key, this.toDoItems, this.storage}) : super(key: key);

  @override
  _ToDoHomeState createState() => new _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHomeWidget> {
  final TextEditingController _listTitleController = new TextEditingController();

  void _handleAddToDoPress() {
    showDialog(
      context: context,
      barrierDismissible: true,
      child: new SimpleDialog(
        title: WidgetHelper.dialogTitleWithClose("New List"),
        children: <Widget>[
          WidgetHelper.textField("Title", _listTitleController),
          new Container(
            padding: const EdgeInsets.only(top:30.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: new MaterialButton(
              onPressed: _handleNewListSave,
              child: const Text('Save'),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  void _handleNewListSave() {
    String title = _listTitleController.text;
    Uuid uuid = new Uuid();

    if (title.length > 0) {
      var newList = new ToDoList(
        id: uuid.v1(),
        title: title.trim(),
        items: new List()
      );

      setState(() {
        widget.toDoItems.add(newList);
      });

      widget.storage.updateListStorage(newList);
    }

    _listTitleController.clear();
    Navigator.pop(context, false);
  }

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
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: new Icon(Icons.add),
        onPressed: _handleAddToDoPress
    ),
    );
  }
}
