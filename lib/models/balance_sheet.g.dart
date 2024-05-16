// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_sheet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BalanceSheetAdapter extends TypeAdapter<BalanceSheet> {
  @override
  final int typeId = 1;

  @override
  BalanceSheet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BalanceSheet(
      fields[0] == null ? 'default value' : fields[0] as String,
      fields[1] == null ? [] : (fields[1] as List).cast<TransactionResult>(),
      fields[2] == null ? [] : (fields[2] as List).cast<Transaction>(),
    );
  }

  @override
  void write(BinaryWriter writer, BalanceSheet obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.results)
      ..writeByte(2)
      ..write(obj.log);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceSheetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
