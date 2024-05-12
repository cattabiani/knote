import 'package:hive/hive.dart';

part 'balanceSheet.g.dart'; // This is the generated file

@HiveType(typeId: 1) // Assign a typeId for your class
class BalanceSheet  {
  @HiveField(0, defaultValue: "default Value")
  String title;

  @HiveField(1, defaultValue: [["self"]])
  List results;

  BalanceSheet(this.title, this.results);
}
