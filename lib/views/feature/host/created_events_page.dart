import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class CreatedEventsPage extends StatefulWidget {
  const CreatedEventsPage({super.key});

  @override
  State<CreatedEventsPage> createState() => _CreatedEventsPageState();
}

class _CreatedEventsPageState extends State<CreatedEventsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          if (!AuthService().isProfileComplete()) {
            AlertService().showAlert(
                'Noch nicht moeglich', 'profile_incomplete', context);
          } else {
            Navigator.pushNamed(context, 'create_event_page_1');
          }
        },
      ),
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
                  isEqualTo: AuthService().getCurrentFirebaseUser()!.uid)
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
