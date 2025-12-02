import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/parking_provider.dart';
import '../models/parking_models.dart';
import 'spot_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParkingProvider>(context);
    final spots = provider.searchSpots(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Parking'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildHomeView(spots)
          : _buildBookingsView(provider),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Find Spots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'My Bookings',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeView(List<ParkingSpot> spots) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search location...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpotDetailsScreen(spot: spot),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                            child: Image.network(
                              spot.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: spot.isAvailable ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                spot.isAvailable ? 'Available' : 'Full',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  spot.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 18),
                                    Text(' ${spot.rating}'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              spot.address,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${spot.pricePerHour.toStringAsFixed(2)} / hr',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookingsView(ParkingProvider provider) {
    final bookings = provider.bookings;
    
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No bookings yet',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.local_parking, color: Colors.blue),
            ),
            title: Text(booking.spotName),
            subtitle: Text(
              '${booking.startTime.toString().substring(0, 16)}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${booking.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  booking.status.toUpperCase(),
                  style: const TextStyle(fontSize: 10, color: Colors.green),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
