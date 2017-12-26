import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../shared/item.dart';
import '../shared/storage.dart';

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
      subtitle: new Text(item.description, style: _getTextStyle(context))
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
  Set<Item> _completedItems = new Set<Item>();

  final TextEditingController _newItemTitle = new TextEditingController();
  final TextEditingController _newItemDescription = new TextEditingController();

  void _handleToDoListChange(Item item, bool inList) {
    setState(() {
      if (inList)
        _completedItems.add(item);
      else
        _completedItems.remove(item);
    });
  }

  void _handleAddItemPress() {
    Widget dialogTitle = new Row(
      children: <Widget>[
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Container(
                child: new Text(
                  "New To Do",
                  style: new TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 24.0
                  ),
                )
              )
            ],
          ),
        ),
        new CloseButton()
      ],
    );

    Container buildTextField(String label, TextEditingController controller) {
      return new Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: new TextField(
          controller: controller,
          decoration: new InputDecoration(
            hintText: label,
          )
        )
      );
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      child: new SimpleDialog(
        title: dialogTitle,
        children: <Widget>[    
          buildTextField("Title", _newItemTitle),
          buildTextField("Description", _newItemDescription),
          new Container(
            padding: const EdgeInsets.all(10.0),
            child: new MaterialButton(
              onPressed: () {
                _handleNewItemSave();
              },
              child: const Text('Save'),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  void _handleNewItemSave() {
    String title = _newItemTitle.text;
    String description = _newItemDescription.text;
    Storage storage = new Storage();
    Uuid uuid = new Uuid();

    if (title.length > 0 && description.length > 0) {
      Item newItem = new Item(
        id: uuid.v1(), 
        title: title.trim(), 
        description: description.trim()
      );

      storage.addToDoItem(newItem);
      setState(() {
        widget.items.add(newItem);
      });
    }

    // clear then close the modal
    _newItemTitle.clear();
    _newItemDescription.clear();
    Navigator.pop(context, false);
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
            inList: _completedItems.contains(item),
            onListChanged: _handleToDoListChange,
          );
        }).toList(),
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: new Icon(Icons.add),
        onPressed: _handleAddItemPress,
      ),
    );
  }
}
