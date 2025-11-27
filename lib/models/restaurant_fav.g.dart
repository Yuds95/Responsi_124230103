// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_fav.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantFavAdapter extends TypeAdapter<RestaurantFav> {
  @override
  final int typeId = 0;

  @override
  RestaurantFav read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantFav(
      id: fields[0] as String,
      name: fields[1] as String,
      city: fields[2] as String,
      rating: fields[3] as double,
      pictureId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantFav obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.pictureId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantFavAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
