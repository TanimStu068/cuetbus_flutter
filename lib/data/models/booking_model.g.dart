// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final int typeId = 0;

  @override
  Booking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Booking(
      busNo: fields[0] as String,
      route: fields[1] as String,
      tripTime: fields[2] as String,
      seats: (fields[3] as List).cast<int>(),
      bookingDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.busNo)
      ..writeByte(1)
      ..write(obj.route)
      ..writeByte(2)
      ..write(obj.tripTime)
      ..writeByte(3)
      ..write(obj.seats)
      ..writeByte(4)
      ..write(obj.bookingDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
