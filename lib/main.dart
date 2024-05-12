import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'balanceSheet.dart';
import 'item.dart';
import 'mainScreen.dart';

void main() async {
  await Hive.initFlutter();

  // Register adapter
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(BalanceSheetAdapter());

  var box = await Hive.openBox("box0");

  runApp(KNoteApp());
}

class KNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KNote',
      home: KNoteMainScreen(),
    );
  }
}



