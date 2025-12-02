class ParkingSpot {
  final String id;
  final String name;
  final String address;
  final double pricePerHour;
  final double rating;
  final String imageUrl;
  final bool isAvailable;
  final double latitude;
  final double longitude;

  ParkingSpot({
    required this.id,
    required this.name,
    required this.address,
    required this.pricePerHour,
    required this.rating,
    required this.imageUrl,
    required this.isAvailable,
    required this.latitude,
    required this.longitude,
  });
}

class Booking {
  final String id;
  final String spotId;
  final String spotName;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String status; // 'active', 'completed', 'cancelled'

  Booking({
    required this.id,
    required this.spotId,
    required this.spotName,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });
}
