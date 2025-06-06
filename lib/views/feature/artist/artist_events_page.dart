import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/event_tile.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/event.dart';
import '../../../services/firestore/event_doc.service.dart';
import '../../../widgets/custom_icon_button.dart';

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
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
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
                child: DefaultTabController(
                  length: 2, // Specify the number of tabs
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TabBar(
                          tabs: [
                            Tab(text: 'Anstehend'),
                            Tab(text: 'Vergangen'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            FirestoreListView<Event>(
                              emptyBuilder: (context) {
                                return const Center(
                                  child: Text('Keine Events'),
                                );
                              },
                              query: _getUpcomingEventsQuery(artistId),
                              itemBuilder: (context, snapshot) {
                                Event event = snapshot.data();
                                return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: EventTile(event: event));
                              },
                            ),
                            FirestoreListView<Event>(
                              emptyBuilder: (context) {
                                return const Center(
                                  child: Text('Keine Events'),
                                );
                              },
                              query: _getPastEventsQuery(artistId),
                              itemBuilder: (context, snapshot) {
                                Event event = snapshot.data();
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EventTile(event: event),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Query<Event> _getUpcomingEventsQuery(String artistId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    var query = EventDocService()
        .eventsCollection
        .orderBy('startDate')
        .where('startDate', isGreaterThanOrEqualTo: startOfDay);

    return query.where('artists', arrayContains: artistId);
  }

  Query<Event> _getPastEventsQuery(String artistId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    var query = EventDocService()
        .eventsCollection
        .orderBy('startDate')
        .where('startDate', isLessThan: startOfDay);

    return query.where('artists', arrayContains: artistId);
  }
}
