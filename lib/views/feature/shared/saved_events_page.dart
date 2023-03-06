import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class SavedEventsPage extends StatefulWidget {
  const SavedEventsPage({super.key});

  @override
  State<SavedEventsPage> createState() => _SavedEventsPageState();
}

class _SavedEventsPageState extends State<SavedEventsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FirestoreListView<Event>(
        emptyBuilder: (context) {
          return const Center(
            child: Text('Keine Events'),
          );
        },
        query: FirestoreService().eventsCollection.where(FieldPath.documentId,
            whereIn: AuthService().currentUser!.savedEvents),
        itemBuilder: (context, snapshot) {
          Event event = snapshot.data();
          return EventCard(event: event);
        },
      ),
    );
  }
}
