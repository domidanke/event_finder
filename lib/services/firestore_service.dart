import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';

class FirestoreService {
  factory FirestoreService() {
    return _singleton;
  }
  FirestoreService._internal();
  static final FirestoreService _singleton = FirestoreService._internal();

  static final db = FirebaseFirestore.instance;
  Stream<List<Event>> get entries => _entriesStreamController.stream;
  late final StreamController<List<Event>> _entriesStreamController =
      StreamController.broadcast();

  void setUserType() async {
    var docSnapshot = await db
        .collection('Admins')
        .doc(AuthService().getCurrentFirebaseUser()?.uid)
        .get();
    if (docSnapshot.exists) {
      AuthService().currentUsertype =
          UserType.fromJson(docSnapshot.data()?['type']);
    } else {
      AuthService().currentUsertype = UserType.base;
    }
  }

  Future<void> writeEventToFirebase(Event event) async {
    eventsCollection.add(event);
  }

  final eventsCollection = db.collection('Events').withConverter<Event>(
        fromFirestore: (snapshot, _) {
          if (snapshot.exists) return Event.fromJson(snapshot.data()!);
          throw Exception('RIP');
        },
        toFirestore: (event, _) => event.toJson(),
      );
}
