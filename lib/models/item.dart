import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 1)
class KItem {
  @HiveField(0)
  String name;
  @HiveField(1)
  String info;

  KItem(this.name, this.info);
  KItem.defaults(this.name) : info = "";
}
