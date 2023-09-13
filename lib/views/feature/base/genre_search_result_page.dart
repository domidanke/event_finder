import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:event_finder/widgets/event_tile.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../widgets/artist_bubble.dart';

class GenreSearchResultPage extends StatefulWidget {
  const GenreSearchResultPage({Key? key}) : super(key: key);

  @override
  State<GenreSearchResultPage> createState() => _GenreSearchResultPageState();
}

class _GenreSearchResultPageState extends State<GenreSearchResultPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        CustomIconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Text(
                      StateService().lastSelectedGenre!,
                      style:
                          const TextStyle(fontSize: 32, color: secondaryColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: const Text(
                              'Künstler',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(),
                          SizedBox(
                            height: 150,
                            child: FirestoreListView<AppUser>(
                              scrollDirection: Axis.horizontal,
                              emptyBuilder: (context) {
                                return const Center(
                                  child: Text('Keine Artists'),
                                );
                              },
                              query: _getArtistQuery(),
                              itemBuilder: (context, snapshot) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: ArtistBubble(
                                    artist: snapshot.data(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            child: const Text(
                              'Events',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 300,
                            child: FirestoreListView<Event>(
                              emptyBuilder: (context) {
                                return const Center(
                                  child: Text('Keine Events'),
                                );
                              },
                              query: _getEventsQuery(),
                              itemBuilder: (context, snapshot) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: EventTile(event: snapshot.data()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Query<Event> _getEventsQuery() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    var query = EventDocService()
        .eventsCollection
        .orderBy('startDate')
        .where('startDate', isGreaterThanOrEqualTo: startOfDay)
        .where('genres', arrayContains: StateService().lastSelectedGenre);

    return query;
  }

  Query<AppUser> _getArtistQuery() {
    var query = UserDocService()
        .usersCollection
        .where(
          'type',
          isEqualTo: 'artist',
        )
        .orderBy('displayName');

    query =
        query.where('genres', arrayContains: StateService().lastSelectedGenre);

    return query;
  }
}
