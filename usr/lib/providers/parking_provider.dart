import 'package:flutter/material.dart';
import '../models/parking_models.dart';

class ParkingProvider with ChangeNotifier {
  // Mock Data
  final List<ParkingSpot> _spots = [
    ParkingSpot(
      id: '1',
      name: 'Downtown Plaza Garage',
      address: '123 Main St, City Center',
      pricePerHour: 5.0,
      rating: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1470224114660-3f6686c562eb?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      latitude: 37.7749,
      longitude: -122.4194,
    ),
    ParkingSpot(
      id: '2',
      name: 'Central Park Lot',
      address: '45 Park Ave, Green District',
      pricePerHour: 3.5,
      rating: 4.2,
      imageUrl: 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      latitude: 37.7849,
      longitude: -122.4094,
    ),
    ParkingSpot(
      id: '3',
      name: 'Mall Underground',
      address: '88 Shopping Blvd, West Side',
      pricePerHour: 2.0,
      rating: 3.8,
      imageUrl: 'https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?auto=format&fit=crop&w=800&q=80',
      isAvailable: false,
      latitude: 37.7649,
      longitude: -122.4294,
    ),
    ParkingSpot(
      id: '4',
      name: 'Airport Long Term',
      address: '100 Airport Way',
      pricePerHour: 8.0,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1590674899484-d5640e854abe?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      latitude: 37.6213,
      longitude: -122.3790,
    ),
  ];

  final List<Booking> _bookings = [];

  List<ParkingSpot> get spots => _spots;
  List<Booking> get bookings => _bookings;

  // Filter spots
  List<ParkingSpot> searchSpots(String query) {
    if (query.isEmpty) return _spots;
    return _spots.where((spot) => 
      spot.name.toLowerCase().contains(query.toLowerCase()) || 
      spot.address.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Create a booking
  Future<bool> createBooking(ParkingSpot spot, DateTime start, DateTime end) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    final duration = end.difference(start).inHours;
    final totalPrice = duration * spot.pricePerHour;

    final newBooking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      spotId: spot.id,
      spotName: spot.name,
      startTime: start,
      endTime: end,
      totalPrice: totalPrice > 0 ? totalPrice : spot.pricePerHour, // Minimum 1 hour charge logic
      status: 'active',
    );

    _bookings.insert(0, newBooking);
    notifyListeners();
    return true;
  }

  // Cancel booking
  void cancelBooking(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      // In a real app, we would update status, but for now let's just remove or mark cancelled
      // _bookings[index] = ... copyWith(status: 'cancelled');
      _bookings.removeAt(index); // Simple remove for demo
      notifyListeners();
    }
  }
}
