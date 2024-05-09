import 'package:hive/hive.dart';

part 'balanceSheet.g.dart'; // This is the generated file

@HiveType(typeId: 1) // Assign a typeId for your class
class BalanceSheet  {
  @HiveField(0)
  String title;

  BalanceSheet(this.title);
}
