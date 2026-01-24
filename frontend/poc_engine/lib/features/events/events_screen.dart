import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../routes/app_routes.dart';
import 'event_model.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<EventModel> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final data = await ApiClient.get('/events');
    setState(() {
      events = (data['events'] as List)
          .map((e) => EventModel.fromJson(e))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Events')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (_, i) {
          final e = events[i];
          return ListTile(
            title: Text(e.name),
            subtitle: Text(e.location),
            trailing: const Icon(Icons.qr_code),
            onTap: () => Navigator.pushNamed(context, AppRoutes.scan),
          );
        },
      ),
    );
  }
}
