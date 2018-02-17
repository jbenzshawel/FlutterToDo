// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => new Item(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    complete: json['complete'] as bool);

abstract class _$ItemSerializerMixin {
  String get id;
  String get title;
  String get description;
  bool get complete;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'complete': complete
      };
}
