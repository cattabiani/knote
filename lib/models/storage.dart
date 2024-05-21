import 'package:hive/hive.dart';
import 'item.dart';

part 'storage.g.dart';

@HiveType(typeId: 0)
class KStorage {
  @HiveField(0)
  List<KItem> items = [];

  KStorage(this.items);
  KStorage.defaults() : items = [];
}
