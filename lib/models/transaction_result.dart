import 'package:hive/hive.dart';

part 'transaction_result.g.dart'; // This is the generated file

@HiveType(typeId: 3) // Assign a typeId for your class
class TransactionResult {
  @HiveField(0, defaultValue: "default Value")
  String person;
  @HiveField(1)
  List<int> creditors;

  TransactionResult.defaults(int creditorLength)
      : person = creditorLength == 0 ? 'self' : 'Person $creditorLength',
        creditors =
            List<int>.generate(creditorLength, (index) => 0, growable: true);
  TransactionResult(this.person, this.creditors);

  void removePerson(int index) {
    creditors.removeAt(index);
  }
}
