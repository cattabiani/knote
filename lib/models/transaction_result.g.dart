// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionResultAdapter extends TypeAdapter<TransactionResult> {
  @override
  final int typeId = 3;

  @override
  TransactionResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionResult(
      fields[0] == null ? 'default Value' : fields[0] as String,
      (fields[1] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionResult obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.person)
      ..writeByte(1)
      ..write(obj.creditors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
