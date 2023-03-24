import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class HostEventsPage extends StatefulWidget {
  const HostEventsPage({super.key});

  @override
  State<HostEventsPage> createState() => _HostEventsPageState();
}

class _HostEventsPageState extends State<HostEventsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FirestoreListView<Event>(
          emptyBuilder: (context) {
            return const Center(
              child: Text('Keine Events'),
            );
          },
          query: FirestoreService()
              .eventsCollection
              .where('creatorId',
                  isEqualTo: StateService().lastSelectedHost!.uid)
              .orderBy('date'),
          itemBuilder: (context, snapshot) {
            Event event = snapshot.data();
            return EventCard(event: event);
          },
        ),
      ),
    );
  }
}
