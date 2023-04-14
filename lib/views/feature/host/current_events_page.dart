import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../widgets/kk_back_button.dart';

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
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: primaryWhite,
        ),
        onPressed: () {
          if (!StateService().isProfileComplete()) {
            AlertService().showAlert(
                'Noch nicht moeglich', 'profile_incomplete', context);
          } else {
            Navigator.pushNamed(context, 'create_event_page_1');
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  KKBackButton(),
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
                  return EventCard(event: event);
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
        .orderBy('date')
        .where('date', isGreaterThanOrEqualTo: startOfDay);
  }
}
