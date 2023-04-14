import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../widgets/kk_back_button.dart';

class ArtistEventsPage extends StatefulWidget {
  const ArtistEventsPage({super.key});

  @override
  State<ArtistEventsPage> createState() => _ArtistEventsPageState();
}

class _ArtistEventsPageState extends State<ArtistEventsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final artistId = StateService().currentUser!.type == UserType.artist
        ? StateService().currentUser!.uid
        : StateService().lastSelectedArtist!.uid;
    return Scaffold(
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
                query: EventDocService()
                    .eventsCollection
                    .where('artists', arrayContains: artistId)
                    .orderBy('date'),
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
}
