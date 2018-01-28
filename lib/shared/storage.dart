import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'item.dart';
import 'item_list.dart';

class Storage {
  Map<String, ItemList> _itemListCache;

  Future<Map<String, ItemList>> getToDoLists() async {
    if (_itemListCache != null) return _itemListCache;

    _itemListCache = new Map<String, ItemList>();

    try {
      String fileContents = await (await _getLocalFile()).readAsString();

      for (dynamic itemList in JSON.decode(fileContents)) {
        String listId = itemList["id"];
        List<Item> items = itemList["items"].map((itemHash) => new Item.fromJson(itemHash)).toList();
        _itemListCache[listId] = new ItemList(id: listId, title: itemList["title"], items: items);
      }
    } catch (e, s) {
      _handleException(e, s);
    }

    return _itemListCache;
  }

  Future<ItemList> getToDoItemList(String listId) async {
    Map<String, ItemList> itemListMap = await getToDoLists();

    if (itemListMap.containsKey(listId)) {
      return itemListMap[listId];
    }

    return null;
  }

  Future<List<Item>> getToDoItems(String listId) async {
    ItemList itemList = await getToDoItemList(listId);

    if (itemList != null) {
      return itemList.items;
    }

    return null;
  }

  Future<Null> addToDoItem(String listId, Item item) async {
    Map<String, ItemList> itemListMap = await getToDoLists();
    
    if (!itemListMap.containsKey(listId)) {
      throw new Exception('ItemList with id $listId does not exist.');
    }

    if (itemListMap[listId].items.any((i) => i.id == item.id)) {
      throw new Exception('Item with id ${item.id} already exists in storage.');
    }

    itemListMap[listId].items.add(item);
    
    _updateStorage(itemListMap);
  }

  Future<Null> deleteToDoItem(String listId, Item item) async {
    Map<String, ItemList> itemListMap = await getToDoLists();
    
    if (!itemListMap.containsKey(listId)) {
      throw new Exception('ItemList with id $listId does not exist.');
    }
  
    if (!itemListMap[listId].items.any((i) => i.id == item.id)) {
      throw new Exception('Item with id ${item.id} does not exists in storage.');
    }

    itemListMap[listId].items.removeWhere((i) => i.id == item.id);
    _updateStorage(itemListMap);
  }

  Future<Null> updateToDoItem(String listId, Item item) async {
    Map<String, ItemList> itemListMap = await getToDoLists();
    
    if (!itemListMap.containsKey(listId)) {
      throw new Exception('ItemList with id $listId does not exist.');
    }
  
    if (!itemListMap[listId].items.any((i) => i.id == item.id)) {
      throw new Exception('Item with id ${item.id} does not exists in storage.');
    }

    Item itemToUpdate = itemListMap[listId].items.firstWhere((i) => i.id == item.id);

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

  Future<Null> _updateStorage(Map<String, ItemList> itemListMap) async {
    try {
      // update cache 
      _itemListCache = itemListMap;

      // update file storage
      String fileContents = JSON.encode(_itemListCache.values.toList());
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