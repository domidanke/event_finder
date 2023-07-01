import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_icon_button.dart';

class CurrentEventsPage extends StatefulWidget {
  const CurrentEventsPage({super.key});

  @override
  State<CurrentEventsPage> createState() => _CurrentEventsPageState();
}

class _CurrentEventsPageState extends State<CurrentEventsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FirestoreListView<Event>(
                emptyBuilder: (context) {
                  return const Center(
                    child: Text('Keine Events'),
                  );
                },
                query: _getQuery(),
                itemBuilder: (context, snapshot) {
                  Event event = snapshot.data();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: EventCard(event: event),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Query<Event> _getQuery() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return EventDocService()
        .eventsCollection
        .where('creatorId',
            isEqualTo: AuthService().getCurrentFirebaseUser()!.uid)
        .orderBy('startDate')
        .where('startDate', isGreaterThanOrEqualTo: startOfDay);
  }
}
