import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'item.dart';
import 'screen.dart';

void main() async {
  await Hive.initFlutter();

  // Register adapter
  Hive.registerAdapter(ItemAdapter());

  var box = await Hive.openBox("box0");

  runApp(KNoteApp());
}

class KNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KNote',
      home: KNoteScreen(),
    );
  }
}



