import 'package:flutter/material.dart';
import '../shared/item.dart';

typedef void ListChangedCallback(Item item, bool inCart);

class ToDoListItem extends StatelessWidget {
  ToDoListItem({Item item, this.inList, this.onListChanged})
      : item = item,
        super(key: new ObjectKey(item));

  final Item item;
  final bool inList;
  final ListChangedCallback onListChanged;

  Color _getColor(BuildContext context) {
    return inList ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!inList) return null;

    return new TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: () {
        onListChanged(item, !inList);
      },
      leading: new CircleAvatar(
        backgroundColor: _getColor(context),
        child: new Text(item.title[0]),
      ),
      title: new Text(item.title, style: _getTextStyle(context)),
      subtitle: new Text(item.description, style: _getTextStyle(context),
      )
    );
  }
}

class ToDoList extends StatefulWidget {
  ToDoList({Key key, this.items}) : super(key: key);

  final List<Item> items;

  @override
  _ToDoListState createState() => new _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  Set<Item> _toDoListItems = new Set<Item>();

  void _handleToDoListChange(Item item, bool inList) {
    setState(() {
      if (inList)
        _toDoListItems.add(item);
      else
        _toDoListItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('To Do List'),
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: widget.items.map((Item item) {
          return new ToDoListItem(
            item: item,
            inList: _toDoListItems.contains(item),
            onListChanged: _handleToDoListChange,
          );
        }).toList(),
      ),
    );
  }
}