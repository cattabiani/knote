import 'package:hive/hive.dart';

part 'transaction.g.dart'; // This is the generated file

@HiveType(typeId: 2) // Assign a typeId for your class
class Transaction {
  @HiveField(0, defaultValue: "default Value")
  String title;
  @HiveField(1, defaultValue: 0)
  int creditor;
  @HiveField(2, defaultValue: 0)
  int amount;
  @HiveField(3, defaultValue: [])
  List<bool> debtors;

  Transaction.defaults(int transactionListLength, int debtorsLength)
      : title = "Transaction $transactionListLength",
        creditor = 0,
        amount = 0,
        debtors =
            List<bool>.generate(debtorsLength, (index) => true, growable: true);
  Transaction(this.title, this.creditor, this.amount, this.debtors);
  void removePerson(int index) {
    debtors.removeAt(index);
    if (creditor == index) {
      creditor = 0;
    }

    if (creditor > index) {
      --creditor;
    }
  }

  void addPerson() {
    debtors.add(false);
  }
}
