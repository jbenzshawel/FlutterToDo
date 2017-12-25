import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'item.dart';

class Storage {

  Future<List<Item>> getToDoItems() async {
    List<Item> toDoItems = [];

    try {
      String fileContents = await (await _getLocalFile()).readAsString();

      for (dynamic item in JSON.decode(fileContents)) {
        toDoItems.add(new Item(id: item["id"], title: item["title"], description: item["description"]));
      }
    } catch (e, s) {
      _handleException(e, s);
    }
    
    return toDoItems;
  }

  Future<Null> updateStorage(List<Item> toDoItems) async {
    try {
      String fileContents = JSON.encode(toDoItems);
      await (await _getLocalFile()).writeAsString(fileContents);
    } catch (e, s) {
      _handleException(e, s);
    }
  }

  Future<String> _localStorageFilePath() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return '$dir/storageList.json';
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

  void _handleException(dynamic exception, StackTrace stackTrace) {
    print('Exception details:\n $exception');
    print('Stack trace:\n $stackTrace');
  }
}