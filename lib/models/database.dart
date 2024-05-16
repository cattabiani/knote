import 'package:hive_flutter/hive_flutter.dart';

class KNoteDataBase {
  List items = [];

  final _box = Hive.box("box0");

  void load() {
    var temp = _box.get("items");
    if (temp == null) {
      // initial data
      items = [];
    } else {
      items = temp;
    }
  }

  void update() {
    _box.put("items", items);
  }

  void clear() {
    items = [];
    update();
  }
}
