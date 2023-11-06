import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/event.dart';
import '../../../services/firestore/event_doc.service.dart';
import '../../../theme/theme.dart';
import '../../../widgets/rating_event_tile.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({super.key});

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  // Doing this so the modal sheet doesn't glitch weirdly
  Future<int> fetchNumber() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<StateService>(context).currentUser;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 42),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 32,
                        )),
                  ],
                ),
              ),
              FutureBuilder(
                future: fetchNumber(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return Expanded(
                      child: FirestoreListView(
                        query: _getQuery(),
                        itemBuilder: (BuildContext context, snapshot) {
                          final event = snapshot.data();
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RatingEventTile(event: event),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Query<Event> _getQuery() {
    final eventsToBeRated = StateService().currentUser!.eventsToBeRated;
    var query = EventDocService().eventsCollection.orderBy('startDate');
    return query.where(FieldPath.documentId, whereIn: eventsToBeRated);
  }
}
