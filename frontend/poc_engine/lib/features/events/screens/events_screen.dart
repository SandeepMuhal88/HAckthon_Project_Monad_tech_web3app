import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';
import '../../../routes/app_routes.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<dynamic> eventsFuture;
  String? userName;
  String? userAddress;

  @override
  void initState() {
    super.initState();
    eventsFuture = ApiService.getEvents();
    _loadUserData();
  }

  void _loadUserData() async {
    final name = await StorageService.getUserName();
    final address = await StorageService.getUserAddress();
    setState(() {
      userName = name;
      userAddress = address;
    });
  }

  void _logout() async {
    await StorageService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultural Events'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => eventsFuture = ApiService.getEvents()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No events found'));
          }

          final data = snapshot.data;
          final events = data['events'] ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => eventsFuture = ApiService.getEvents());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(
                  event: event,
                  userAddress: userAddress ?? '',
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final dynamic event;
  final String userAddress;

  const EventCard({
    Key? key,
    required this.event,
    required this.userAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['name'] ?? 'Event',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            event['location'] ?? 'Unknown',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (event['description'] != null) ...[
              Text(
                event['description'],
                style: const TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Capacity: ${event['capacity'] ?? 'N/A'} | Attendees: ${event['attendees'] ?? 0}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.qrScanner,
                    arguments: {
                      'eventId': event['id'],
                      'eventName': event['name'],
                      'userAddress': userAddress,
                    },
                  );
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Verify Attendance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
