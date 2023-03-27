import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/models/ticket_info.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/event_ticket.dart';

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
      type: user.isAnonymous ? UserType.guest : UserType.base,
      displayName: user.displayName ?? '',
    );
    await usersCollection
        .doc(AuthService().getCurrentFirebaseUser()!.uid)
        .set(newUser);
  }

  Future<void> upgradeUserDocument() async {
    var user = AuthService().currentUser!;
    user.type = UserType.base;
    await usersCollection
        .doc(AuthService().getCurrentFirebaseUser()!.uid)
        .set(user);
  }

  Future<AppUser> getUserData() async {
    final doc = await usersCollection
        .doc(AuthService().getCurrentFirebaseUser()!.uid)
        .get();
    return doc.data()!;
  }

  Future<String> addEventDocument(Event event) async {
    final ref = await eventsCollection.add(event);
    await eventTicketsCollection
        .doc(ref.id)
        .set(EventTicket(allTickets: [], usedTickets: []));
    return ref.id;
  }

  Future<void> updateEventDocument(
      Map<String, Object?> map, String eventId) async {
    await eventsCollection.doc(eventId).update(map);
  }

  Future<void> deleteEventDocument(Event event) async {
    await eventsCollection.doc(event.uid).delete();
  }

  Future<void> updateEventArtists() async {
    final artistIds = StateService().lastSelectedEvent!.artists;
    // Array Union is for safety here
    await eventsCollection
        .doc(StateService().lastSelectedEvent!.uid)
        .update({'artists': FieldValue.arrayUnion(artistIds)});
  }

  Future<void> toggleSaveEventForUser() async {
    await usersCollection
        .doc(AuthService().getCurrentFirebaseUser()?.uid)
        .update({'savedEvents': AuthService().currentUser!.savedEvents});
  }

  Future<void> toggleSaveArtistForUser(String artistUid) async {
    if (AuthService().currentUser!.savedArtists.contains(artistUid)) {
      await usersCollection
          .doc(AuthService().getCurrentFirebaseUser()?.uid)
          .update({
        'savedArtists': FieldValue.arrayRemove([artistUid])
      });
    } else {
      await usersCollection
          .doc(AuthService().getCurrentFirebaseUser()?.uid)
          .update({
        'savedArtists': FieldValue.arrayUnion([artistUid])
      });
    }
  }

  Future<void> toggleFollowerForArtist(String artistUid) async {
    if (AuthService().currentUser!.savedArtists.contains(artistUid)) {
      await usersCollection.doc(artistUid).update({
        'follower': FieldValue.arrayRemove([AuthService().currentUser!.uid])
      });
    } else {
      await usersCollection.doc(artistUid).update({
        'follower': FieldValue.arrayUnion([AuthService().currentUser!.uid])
      });
    }
  }

  Future<void> toggleSaveHostForUser(String hostUid) async {
    if (AuthService().currentUser!.savedHosts.contains(hostUid)) {
      await usersCollection
          .doc(AuthService().getCurrentFirebaseUser()?.uid)
          .update({
        'savedHosts': FieldValue.arrayRemove([hostUid])
      });
    } else {
      await usersCollection
          .doc(AuthService().getCurrentFirebaseUser()?.uid)
          .update({
        'savedHosts': FieldValue.arrayUnion([hostUid])
      });
    }
  }

  Future<void> toggleFollowerForHost(String hostUid) async {
    if (AuthService().currentUser!.savedHosts.contains(hostUid)) {
      await usersCollection.doc(hostUid).update({
        'follower': FieldValue.arrayRemove([AuthService().currentUser!.uid])
      });
    } else {
      await usersCollection.doc(hostUid).update({
        'follower': FieldValue.arrayUnion([AuthService().currentUser!.uid])
      });
    }
  }

  Future<void> saveMainLocationData(LatLng coordinates) async {
    await usersCollection
        .doc(AuthService().currentUser!.uid)
        .update({'mainLocationCoordinates': coordinates.toJson()});
  }

  Future<void> addTicketsToUser(List<TicketInfo> ticketInfos) async {
    await usersCollection.doc(AuthService().currentUser!.uid).update({
      'allTickets':
          FieldValue.arrayUnion(ticketInfos.map((e) => e.toJson()).toList())
    });
    AuthService().currentUser!.allTickets =
        List.from(AuthService().currentUser!.allTickets)..addAll(ticketInfos);
  }

  Future<void> addTicketsToEvent(
      List<TicketInfo> ticketInfos, String eventId) async {
    var ids = ticketInfos.map((e) => e.id).toList();
    await eventTicketsCollection
        .doc(eventId)
        .update({'allTickets': FieldValue.arrayUnion(ids)});
  }

  final usersCollection = db.collection('Users').withConverter<AppUser>(
        fromFirestore: (snapshot, _) {
          if (snapshot.exists) {
            return AppUser.fromJson(snapshot.data()!, snapshot.id);
          }
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

  final eventTicketsCollection =
      db.collection('EventTickets').withConverter<EventTicket>(
            fromFirestore: (snapshot, _) {
              if (snapshot.exists) {
                return EventTicket.fromJson(snapshot.data()!);
              }
              throw Exception('RIP');
            },
            toFirestore: (eventTicket, _) => eventTicket.toJson(),
          );
}
