import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../shared/to_do_list.dart';
import '../shared/widget_helper.dart';
import '../shared/storage.dart';

typedef void RemoveFromListCallback(ToDoList toDoList);

class ToDoItemWidget extends StatelessWidget {
  final ToDoList toDoList;
  final Storage storage;
  final RemoveFromListCallback onRemove;

  ToDoItemWidget({this.toDoList, this.storage, this.onRemove})
    : super(key: new ObjectKey(toDoList));

  void _handleShowToDoList(BuildContext context) {
    Navigator.pushNamed(context, '/list:${toDoList.id}');
  }

  void _deleteListPressed(BuildContext context) {
    void deleteConfirmCallback () {
      onRemove(toDoList);

      storage.deleteList(toDoList);

      Navigator.pop(context, false);
    }

    showDialog(
        context: context,
        barrierDismissible: true,
        child: WidgetHelper.confirmDialogWithClose(
            context,
            'Delete List',
            'Are you sure you want to delete the "${toDoList.title}" list?',
            deleteConfirmCallback
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new ListTile(
            title: new Text(
                toDoList.title,
                style: new TextStyle (color: Colors.blue.shade300)
            ),
            onTap: () {
              _handleShowToDoList(context);
            }
          )
        ),
        new IconButton(
          icon: new Icon(Icons.delete_outline),
            padding: const EdgeInsets.only(bottom: 3.0, right: 3.0),
            onPressed: () {
            _deleteListPressed(context);
            }
        )
      ]);
  }
}

class ToDoHomeWidget extends StatefulWidget {
  final List<ToDoList> toDoLists;
  final Storage storage;


  ToDoHomeWidget({Key key, this.toDoLists, this.storage}) : super(key: key);

  @override
  _ToDoHomeState createState() => new _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHomeWidget> {
  final TextEditingController _listTitleController = new TextEditingController();

  void _onRemoveCallback(ToDoList toDoList) {
    setState(() {
      widget.toDoLists.removeWhere((list) => list.id == toDoList.id);
    });
  }

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
        widget.toDoLists.add(newList);
      });

      widget.storage.updateList(newList);
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
        children: widget.toDoLists.map((ToDoList toDoList) {
          return new ToDoItemWidget(
            toDoList: toDoList,
            storage: widget.storage,
            onRemove: _onRemoveCallback,
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
