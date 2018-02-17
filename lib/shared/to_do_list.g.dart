// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_list.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

ToDoList _$ToDoListFromJson(Map<String, dynamic> json) => new ToDoList(
    id: json['id'] as String,
    title: json['title'] as String,
    items: (json['items'] as List)
        ?.map((e) =>
            e == null ? null : new Item.fromJson(e as Map<String, dynamic>))
        ?.toList());

abstract class _$ToDoListSerializerMixin {
  String get id;
  String get title;
  List<Item> get items;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'title': title, 'items': items};
}
