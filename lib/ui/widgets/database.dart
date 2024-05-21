import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:knote/models/storage.dart';
import 'package:knote/models/item.dart';
import 'package:knote/ui/screens/home_screen.dart';

class KDatabase extends StatefulWidget {
  const KDatabase({super.key});

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(KStorageAdapter());
    Hive.registerAdapter(KItemAdapter());
    // await Hive.deleteBoxFromDisk('KNoteBox');
    await Hive.openBox<KStorage>('KNoteBox');
  }

  @override
  State<KDatabase> createState() => _KDatabaseState();
}

class _KDatabaseState extends State<KDatabase> with WidgetsBindingObserver {
  KStorage storage = KStorage.defaults();
  final Box<KStorage> _box = Hive.box('KNoteBox');

  @override
  void initState() {
    super.initState();
    _load();
    WidgetsBinding.instance.addObserver(this);
  }

  void clear() {
    storage = KStorage.defaults();
  }

  void _load() {
    storage = _box.get("storage") ?? KStorage.defaults();
  }

  void _save() {
    _box.put("storage", storage);
  }

  @override
  Widget build(BuildContext context) {
    return KHomeScreen(storage: storage);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _save();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _save();
    }
  }
}
