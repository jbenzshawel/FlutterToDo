import 'package:json_annotation/json_annotation.dart';

import 'item.dart';

part 'to_do_list.g.dart';

@JsonSerializable()
class ToDoList  extends Object with _$ToDoListSerializerMixin {
  String id;
  String title;
  List<Item> items;

  ToDoList({this.id, this.title, this.items});

  factory ToDoList.fromJson(Map<String, dynamic> json) => _$ToDoListFromJson(json);
}