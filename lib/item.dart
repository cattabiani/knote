import 'package:hive/hive.dart';

part 'item.g.dart'; // This is the generated file

@HiveType(typeId: 0) // Assign a typeId for your class
class Item  {
  @HiveField(0)
  String title;

  @HiveField(1)
  String info;

  Item(this.title, this.info);
}
