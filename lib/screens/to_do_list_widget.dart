import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../shared/item.dart';
import '../shared/storage.dart';
import '../shared/action.dart';
import '../shared/widget_helper.dart';

typedef void ListChangedCallback(Item item, Action action);

class ToDoListItemWidget extends StatelessWidget {
  final Item item;
  final String listId;
  final ListChangedCallback onListChanged;
  final Storage storage;

  ToDoListItemWidget({this.item, this.listId, this.onListChanged, this.storage})
      : super(key: new ObjectKey(item));

  Color _getColor(BuildContext context, bool complete) {
    return complete ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context, bool complete) {
    if (!complete) return null;

    return new TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  void _deleteItemPressed(BuildContext context) {
    void deleteConfirmCallback () {
      // remove the item from the view
      onListChanged(item, Action.delete);

      // remove the item from storage
      storage.updateItem(listId, item);

      // close the modal
      Navigator.pop(context, false);
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      child: WidgetHelper.confirmDialogWithClose(
          context,
          'Delete Item',
          'Are you sure you want to delete the "${item.title}" item?',
          deleteConfirmCallback
      )
    );
  }

  void _itemCompletePressed(Item item) {
    item.complete = !item.complete;

    // update the item in the view
    onListChanged(item, Action.update);

    // update the item in storage
    storage.updateItem(listId, item);
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new ListTile(
            onTap: () {
              _itemCompletePressed(item);
            },
            leading: new CircleAvatar(
              backgroundColor: _getColor(context, item.complete),
              child: new Text(item.title[0]),
            ),
            title: new Text(item.title, style: _getTextStyle(context, item.complete)),
            subtitle: new Text(item.description, style: _getTextStyle(context, item.complete))
          )
        ),
        new IconButton(
          icon: new Icon(Icons.delete_outline),
          padding: const EdgeInsets.only(bottom: 3.0, right: 3.0),
          onPressed: () {
            _deleteItemPressed(context);
          },
        )
    ]);
  }
}

class ToDoListWidget extends StatefulWidget {
  final String listId;
  final String title;
  final List<Item> items;
  final Storage storage;
    
  ToDoListWidget({Key key, this.listId, this.title, this.items, this.storage}) : super(key: key);

  @override
  _ToDoListState createState() => new _ToDoListState();
}

class _ToDoListState extends State<ToDoListWidget> {
  final TextEditingController _itemTitleController = new TextEditingController();
  final TextEditingController _itemDescriptionController = new TextEditingController();

  _changeToDoListState(Item item, Action action) {
    switch (action) {
      case Action.create:
        setState(() {
          widget.items.add(item);
        });
        break;
      case Action.update:
        setState(() {
          Item itemToUpdate = widget.items.firstWhere((i) => i.id == item.id);
          itemToUpdate.title = item.title;
          itemToUpdate.description = item.description;
          itemToUpdate.complete = item.complete;
        });
        break;
      case Action.delete:
        setState(() {
          widget.items.removeWhere((i) => i.id == item.id);
        });
        break;
      default:
        break; // do nothing
    }
  }

  void _handleAddItemPress() {
    showDialog(
      context: context,
      barrierDismissible: true,
      child: new SimpleDialog(
        title: WidgetHelper.dialogTitleWithClose("New Item"),
        children: <Widget>[    
          WidgetHelper.textField("Title", _itemTitleController),
          WidgetHelper.textField("Description", _itemDescriptionController),
          new Container(
            padding: const EdgeInsets.only(top:30.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: new MaterialButton(
              onPressed: _handleNewItemSave,
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
    String title = _itemTitleController.text;
    String description = _itemDescriptionController.text;
    Uuid uuid = new Uuid();

    if (title.length > 0 && description.length > 0) {
      Item newItem = new Item(
        id: uuid.v1(), 
        title: title.trim(), 
        description: description.trim(),
        complete: false
      );

      _changeToDoListState(newItem, Action.create);
      widget.storage.updateItem(widget.listId, newItem);
    }

    // clear then close the modal
    _itemTitleController.clear();
    _itemDescriptionController.clear();
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: widget.items.map((Item item) {
          return new ToDoListItemWidget(
            listId: widget.listId,
            item: item,
            onListChanged: _changeToDoListState,
            storage: widget.storage,
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
