import 'package:hive/hive.dart';

import 'transaction_result.dart';
import 'transaction.dart';

part 'balance_sheet.g.dart'; // This is the generated file

@HiveType(typeId: 1) // Assign a typeId for your class
class BalanceSheet {
  @HiveField(0, defaultValue: "default value")
  String title;

  @HiveField(1, defaultValue: [])
  List<TransactionResult> results;

  @HiveField(2, defaultValue: [])
  List<Transaction> log;

  BalanceSheet.defaults(int balanceSheetN)
      : title = "Balance Sheet $balanceSheetN",
        results = [TransactionResult.defaults(0)],
        log = [];
  BalanceSheet(this.title, this.results, this.log);

  void addPerson() {
    final n = results.length;
    results.add(TransactionResult.defaults(n));

    for (int j = 0; j < log.length; ++j) {
      log[j].addPerson();
    }
  }

  void removePerson(int index) {
    if (results.length <= 1) {
      return;
    }

    for (int j = index + 1; j < results.length; ++j) {
      results[j].removePerson(index);
    }
    for (int j = 0; j < log.length; ++j) {
      log[j].removePerson(index);
    }
    results.removeAt(index);
  }
}
