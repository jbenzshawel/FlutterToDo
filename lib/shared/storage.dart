import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'item.dart';
import 'to_do_list.dart';

class Storage {
  Map<String, ToDoList> toDoListCache;

  Future<Map<String, ToDoList>> getToDoLists() async {
    if (toDoListCache != null) return toDoListCache;

    toDoListCache = new Map<String, ToDoList>();

    try {
      String fileContents = await (await _getLocalFile()).readAsString();

      for (Map itemListMap in JSON.decode(fileContents)) {
        var toDoList = new ToDoList.fromJson(itemListMap);

        toDoListCache[toDoList.id] = toDoList;
      }
    } catch (e, s) {
      _handleException(e, s);
    }

    return toDoListCache;
  }

  Future<ToDoList> getToDoList(String listId) async {
    Map<String, ToDoList> itemListMap = await getToDoLists();

    if (!itemListMap.containsKey(listId)) {
      throw new Exception('ToDoList with id $listId does not exist.');
    }

    return itemListMap[listId];
  }

  Future<List<Item>> getToDoItems(String listId) async {

    return (await getToDoList(listId)).items;
  }

  Future<Null> updateItemStorage(String listId, Item item) async {
    Map<String, ToDoList> itemListMap = await getToDoLists();
    
    if (!itemListMap.containsKey(listId)) {
      throw new Exception('ToDoList with id $listId does not exist.');
    }

    _updateStorage(itemListMap);
  }

  Future<Null> updateListStorage(ToDoList list) async {
    Map<String, ToDoList> itemListMap = await getToDoLists();

    itemListMap[list.id] = list;

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

  Future<Null> _updateStorage(Map<String, ToDoList> itemListMap) async {
    try {
      // update cache
      toDoListCache = itemListMap;

      // update file storage
      String fileContents = JSON.encode(toDoListCache.values.toList());
      await (await _getLocalFile()).writeAsString(fileContents);
    } catch (e, s) {
      _handleException(e, s);
    }
  }
  
  void _handleException(Exception exception, StackTrace stackTrace) {
    // TODO: add logging?
    print('Exception details:\n $exception');
    print('Stack trace:\n $stackTrace');

    throw exception;
  }
}