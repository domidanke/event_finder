import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.map,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'maps_page');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_alt,
              color: Colors.white,
            ),
            onPressed: () {
              _showFiltersSheet();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FirestoreListView<Event>(
            emptyBuilder: (context) {
              return const Center(
                child: Text('Keine Events'),
              );
            },
            query: EventDocService().eventsCollection.orderBy('date'),
            itemBuilder: (context, snapshot) {
              return EventCard(event: snapshot.data());
            },
          ),
        ),
      ),
    );
  }

  void _showFiltersSheet() {
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => const Center(
        child: Text('Filter'),
      ),
    );
  }
}
