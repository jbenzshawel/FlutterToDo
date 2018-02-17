import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item extends Object with _$ItemSerializerMixin {
  String id;  Item({this.id, this.title, this.description, this.complete});

  String title;
  String description;
  bool complete = false;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
