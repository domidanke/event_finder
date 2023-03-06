import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:event_finder/widgets/kk_button.dart';
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
    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 12,
                child: FirestoreListView<Event>(
                  emptyBuilder: (context) {
                    return const Center(
                      child: Text('Keine Events'),
                    );
                  },
                  query: FirestoreService().eventsCollection.where(
                      FieldPath.documentId,
                      whereIn: AuthService().currentUser!.savedEvents),
                  itemBuilder: (context, snapshot) {
                    Event event = snapshot.data();
                    return EventCard(event: event);
                  },
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SizedBox(
                      width: 100,
                      child: KKButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'home');
                        },
                        buttonText: 'Fertig',
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
