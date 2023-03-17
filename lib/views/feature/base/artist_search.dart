import 'package:event_finder/models/app_user.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/firestore_service.dart';

class ArtistSearch extends StatefulWidget {
  const ArtistSearch({super.key});

  @override
  State<ArtistSearch> createState() => _ArtistSearchState();
}

class _ArtistSearchState extends State<ArtistSearch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const <Widget>[
            Text('Filter 1'),
            Text('Filter 2'),
          ],
        ),
        Expanded(
          child: FirestoreListView<AppUser>(
            emptyBuilder: (context) {
              return const Center(
                child: Text('Keine Artists'),
              );
            },
            query: FirestoreService().usersCollection.where(
                  'type',
                  isEqualTo: 'artist',
                ),
            itemBuilder: (context, snapshot) {
              return const Center(child: Text('artist'));
            },
          ),
        ),
      ],
    );
  }
}
