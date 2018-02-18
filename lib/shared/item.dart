import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item extends Object with _$ItemSerializerMixin {
  String id;
  String title;
  String description;
  bool complete = false;

  Item({this.id, this.title, this.description, this.complete});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
