import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/state.service.dart';

class EventDocService {
  factory EventDocService() {
    return _singleton;
  }
  EventDocService._internal();
  static final EventDocService _singleton = EventDocService._internal();

  static final db = FirebaseFirestore.instance;

  final eventsCollection = db.collection('Events').withConverter<Event>(
        fromFirestore: (snapshot, _) {
          if (snapshot.exists) {
            return Event.fromJson(snapshot.data()!, snapshot.id);
          }
          throw Exception('RIP');
        },
        toFirestore: (event, _) => event.toJson(),
      );

  Stream<List<Event>> get entries => _entriesStreamController.stream;
  late final StreamController<List<Event>> _entriesStreamController =
      StreamController.broadcast();

  Future<String> addEventDocument(Event event) async {
    final ref = await eventsCollection.add(event);
    return ref.id;
  }

  Future<void> updateEventDocument(Event event) async {
    await eventsCollection.doc(event.uid).update({'details': event.details});
  }

  Future<void> deleteEventDocument(Event event) async {
    await eventsCollection.doc(event.uid).delete();
  }

  Future<void> updateEventArtists() async {
    final artistIds = StateService().lastSelectedEvent!.artists;
    await eventsCollection
        .doc(StateService().lastSelectedEvent!.uid)
        .update({'artists': artistIds});
  }
}
