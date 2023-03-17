import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<bool> userExists() {
    return usersCollection
        .doc(AuthService().getCurrentFirebaseUser()!.uid)
        .get()
        .then((docSnapshot) => docSnapshot.exists);
  }

  Future<void> addUserDocument(User user) async {
    final newUser = AppUser(
      type: UserType.base,
      displayName: user.displayName ?? '',
    );
    await usersCollection
        .doc(AuthService().getCurrentFirebaseUser()!.uid)
        .set(newUser);
  }

  Future<AppUser> getUserData() async {
    final doc = await usersCollection
        .doc(AuthService().getCurrentFirebaseUser()!.uid)
        .get();
    return doc.data()!;
  }

  Future<String> addEventDocument(Event event) async {
    final ref = await eventsCollection.add(event);
    return ref.id;
  }

  Future<void> updateEventDocument(
      Map<String, Object?> map, String eventId) async {
    await eventsCollection.doc(eventId).update(map);
  }

  Future<void> deleteEventDocument(Event event) async {
    await eventsCollection.doc(event.uid).delete();
  }

  Future<void> toggleSaveEventForUser(Event event) async {
    await usersCollection
        .doc(AuthService().getCurrentFirebaseUser()?.uid)
        .update({'savedEvents': AuthService().currentUser!.savedEvents});
  }

  final usersCollection = db.collection('Users').withConverter<AppUser>(
        fromFirestore: (snapshot, _) {
          if (snapshot.exists) return AppUser.fromJson(snapshot.data()!);
          throw Exception('RIP');
        },
        toFirestore: (event, _) => event.toJson(),
      );

  final eventsCollection = db.collection('Events').withConverter<Event>(
        fromFirestore: (snapshot, _) {
          if (snapshot.exists) {
            return Event.fromJson(snapshot.data()!, snapshot.id);
          }
          throw Exception('RIP');
        },
        toFirestore: (event, _) => event.toJson(),
      );
}
