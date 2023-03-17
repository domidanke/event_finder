import 'package:event_finder/models/app_user.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/firestore_service.dart';

class HostSearch extends StatefulWidget {
  const HostSearch({super.key});

  @override
  State<HostSearch> createState() => _HostSearchState();
}

class _HostSearchState extends State<HostSearch> {
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
                child: Text('Keine Events'),
              );
            },
            query: FirestoreService().usersCollection.where(
                  'type',
                  isEqualTo: 'host',
                ),
            itemBuilder: (context, snapshot) {
              return const Center(child: Text('host'));
            },
          ),
        ),
      ],
    );
  }
}
