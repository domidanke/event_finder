import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_icon_button.dart';

class PastEventsPage extends StatefulWidget {
  const PastEventsPage({super.key});

  @override
  State<PastEventsPage> createState() => _PastEventsPageState();
}

class _PastEventsPageState extends State<PastEventsPage> {
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
        .orderBy('startDate', descending: true)
        .where('startDate', isLessThanOrEqualTo: startOfDay);
  }
}
