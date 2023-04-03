import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Opacity(
            opacity:
                StateService().currentUser!.type == UserType.guest ? 0.2 : 1,
            child: IconButton(
              icon: const Icon(
                Icons.map,
                color: Colors.white,
              ),
              onPressed: () async {
                if (StateService().currentUser!.type == UserType.guest) return;
                StateService().currentUserLocation =
                    await Geolocator.getCurrentPosition();
                if (mounted) Navigator.pushNamed(context, 'maps_page');
              },
            ),
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
            query: _getQuery(),
            itemBuilder: (context, snapshot) {
              return EventCard(event: snapshot.data());
            },
          ),
        ),
      ),
    );
  }

  Query<Event> _getQuery() {
    return EventDocService().eventsCollection.orderBy('date');
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
