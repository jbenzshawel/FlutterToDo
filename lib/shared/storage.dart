import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'list_item.dart';
import 'to_do_item.dart';

class Storage {
  Map<String, ToDoItem> itemListCache;

  Future<Map<String, ToDoItem>> getToDoLists() async {
    if (itemListCache != null) return itemListCache;

    itemListCache = new Map<String, ToDoItem>();

    try {
      String fileContents = await (await _getLocalFile()).readAsString();

      for (dynamic itemList in JSON.decode(fileContents)) {
        String listId = itemList["id"];
        List<ListItem> items = itemList["items"].map((itemHash) => new ListItem.fromJson(itemHash)).toList();
        itemListCache[listId] = new ToDoItem(id: listId, title: itemList["title"], items: items);
      }
    } catch (e, s) {
      _handleException(e, s);
    }

    return itemListCache;
  }

  Future<ToDoItem> getToDoItemList(String listId) async {
    Map<String, ToDoItem> itemListMap = await getToDoLists();

    if (itemListMap.containsKey(listId)) {
      return itemListMap[listId];
    }

    return null;
  }

  Future<List<ListItem>> getToDoItems(String listId) async {
    ToDoItem itemList = await getToDoItemList(listId);

    if (itemList != null) {
      return itemList.items;
    }

    return null;
  }

  Future<Null> addToDoItem(String listId, ListItem item) async {
    Map<String, ToDoItem> itemListMap = await getToDoLists();
    
    if (!itemListMap.containsKey(listId)) {
      throw new Exception('ItemList with id $listId does not exist.');
    }
    
    _updateStorage(itemListMap);
  }

  Future<Null> deleteToDoItem(String listId, ListItem item) async {
    Map<String, ToDoItem> itemListMap = await getToDoLists();
    
    if (!itemListMap.containsKey(listId)) {
      throw new Exception('ItemList with id $listId does not exist.');
    }
    
    _updateStorage(itemListMap);
  }

  Future<Null> updateToDoItem(String listId, ListItem item) async {
    Map<String, ToDoItem> itemListMap = await getToDoLists();
    
    if (!itemListMap.containsKey(listId)) {
      throw new Exception('ItemList with id $listId does not exist.');
    }
  
    if (!itemListMap[listId].items.any((i) => i.id == item.id)) {
      throw new Exception('Item with id ${item.id} does not exists in storage.');
    }

    ListItem itemToUpdate = itemListMap[listId].items.firstWhere((i) => i.id == item.id);

    itemToUpdate.title = item.title;
    itemToUpdate.description = item.description;
    itemToUpdate.complete = item.complete;

    _updateStorage(itemListMap);
  }

  Future<File> _getLocalFile() async {
    String path = await _localStorageFilePath();

    if(FileSystemEntity.typeSync(path) == FileSystemEntityType.NOT_FOUND) {
      File file = await new File(path).create();
      file.writeAsString('''
      [{
        "id" : "b23766f8-d4f5-4506-9262-1d408132f048",
        "title" : "Application Development To Do",
        "items" : [
          {
            "id" : "a01766f8-c4f5-4506-9262-1b408132f048",
            "title" : "Create widget to add to do items",
            "description" : "Create a stateful widget for adding items to the to do list",
            "complete" : false
          }
        ]
      }]
      ''');
      return file;
    }

    return new File(path);
  }

  Future<String> _localStorageFilePath() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return '$dir/storageList.json';
  }

  Future<Null> _updateStorage(Map<String, ToDoItem> itemListMap) async {
    try {
      // update cache
      itemListCache = itemListMap;

      // update file storage
      String fileContents = JSON.encode(itemListCache.values.toList());
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