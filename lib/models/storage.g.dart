// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KStorageAdapter extends TypeAdapter<KStorage> {
  @override
  final int typeId = 0;

  @override
  KStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KStorage(
      (fields[0] as List).cast<KItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, KStorage obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
