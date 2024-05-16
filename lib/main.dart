import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/balance_sheet.dart';
import 'models/transaction.dart';
import 'models/transaction_result.dart';
import 'models/item.dart';
import 'ui/screens/main_screen.dart';

void main() async {
  await Hive.initFlutter();

  // Register adapter
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(BalanceSheetAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionResultAdapter());

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
