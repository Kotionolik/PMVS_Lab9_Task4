class ParkingLot {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final int totalSpots;
  final int freeSpots;
  final double pricePerHour;
  final bool isFavorite;
  ParkingLot({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.totalSpots,
    required this.freeSpots,
    required this.pricePerHour,
    this.isFavorite = false,
  });
  factory ParkingLot.fromMap(Map<String, dynamic> map) {
    return ParkingLot(
      id: map['id'] as int?,
      name: map['name'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      totalSpots: map['total_spots'] as int,
      freeSpots: map['free_spots'] as int,

      pricePerHour: (map['price_per_hour'] as num).toDouble(),
      isFavorite: (map['is_favorite'] as int?) == 1,
    );
  }
  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'latitude': latitude,
    'longitude': longitude, 'total_spots': totalSpots,
    'free_spots': freeSpots, 'price_per_hour': pricePerHour,
    'is_favorite': isFavorite ? 1 : 0,
  };
  ParkingLot copyWith({int? freeSpots, bool? isFavorite}) => ParkingLot(
      id: id, name: name, latitude: latitude, longitude: longitude,
      totalSpots: totalSpots, freeSpots: freeSpots ?? this.freeSpots,
      pricePerHour: pricePerHour, isFavorite: isFavorite ?? this.isFavorite,
    );
}