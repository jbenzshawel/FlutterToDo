import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'item.dart';

class Storage {
  List<Item> _toDoItems;

  Future<Null> addToDoItem(Item item) async {
    List<Item> toDoItems = await getToDoItems();

    if (toDoItems.any((i) => i.id == item.id)) {
      throw new Exception('Item with id $item.id already exists in storage.');
    }

    toDoItems.add(item);
    _updateStorage(toDoItems);
  }

  Future<Null> deleteToDoItem(String id) async {
    List<Item> toDoItems = await getToDoItems();

    Item itemToRemove = toDoItems.firstWhere((i) => i.id == id);
    if (itemToRemove != null) {
      toDoItems.remove(itemToRemove);
    }

    _updateStorage(toDoItems);
  }

  Future<List<Item>> getToDoItems() async {
    if (_toDoItems != null) return _toDoItems;

    _toDoItems = [];

    try {
      String fileContents = await (await _getLocalFile()).readAsString();

      for (dynamic item in JSON.decode(fileContents)) {
        _toDoItems.add(new Item(id: item["id"], title: item["title"], description: item["description"]));
      }
    } catch (e, s) {
      _handleException(e, s);
    }
    
    return _toDoItems;
  }

  Future<File> _getLocalFile() async {
    String path = await _localStorageFilePath();

    if(FileSystemEntity.typeSync(path) == FileSystemEntityType.NOT_FOUND) {
      File file = await new File(path).create();
      file.writeAsString('''
        [
          {
            "id" : "a01766f8-c4f5-4506-9262-1b408132f048",
            "title" : "Create widget to add to do items",
            "description" : "Create a stateful widget for adding items to the to do list"
          }
        ]
      ''');
      return file;
    }

    return new File(path);
  }

  Future<String> _localStorageFilePath() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return '$dir/storageList.json';
  }

  Future<Null> _updateStorage(List<Item> toDoItems) async {
    try {
      // update _toDoItems to match storage 
      _toDoItems = toDoItems; 
      // update file storage with latest to do item object 
      String fileContents = JSON.encode(toDoItems);
      await (await _getLocalFile()).writeAsString(fileContents);
    } catch (e, s) {
      _handleException(e, s);
    }
  }

  void _handleException(dynamic exception, StackTrace stackTrace) {
    print('Exception details:\n $exception');
    print('Stack trace:\n $stackTrace');
  }
}
