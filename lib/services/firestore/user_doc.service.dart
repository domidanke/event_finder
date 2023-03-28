import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/ticket_info.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserDocService {
  factory UserDocService() {
    return _singleton;
  }
  UserDocService._internal();
  static final UserDocService _singleton = UserDocService._internal();

  static final db = FirebaseFirestore.instance;

  final usersCollection = db.collection('Users').withConverter<AppUser>(
        fromFirestore: (snapshot, _) {
          if (snapshot.exists) {
            return AppUser.fromJson(snapshot.data()!, snapshot.id);
          }
          throw Exception('RIP');
        },
        toFirestore: (event, _) => event.toJson(),
      );

  Future<bool> userExists() {
    return usersCollection
        .doc(StateService().currentUser!.uid)
        .get()
        .then((docSnapshot) => docSnapshot.exists);
  }

  Future<void> addUserDocument(User user) async {
    final newUser = AppUser(
      type: user.isAnonymous ? UserType.guest : UserType.base,
      displayName: user.displayName ?? '',
    );
    await usersCollection.doc(StateService().currentUser!.uid).set(newUser);
  }

  Future<void> upgradeUserDocument() async {
    await usersCollection
        .doc(StateService().currentUser!.uid)
        .update({'type': UserType.base});
  }

  Future<AppUser?> getUserData() async {
    if (AuthService().getCurrentFirebaseUser() == null) return null;
    final doc = await usersCollection
        .doc(AuthService().getCurrentFirebaseUser()!.uid)
        .get();
    return doc.data();
  }

  Future<void> saveEvent(String eventId) async {
    final currentUser = StateService().currentUser!;
    if (currentUser.savedEvents.contains(eventId)) {
      await usersCollection.doc(currentUser.uid).update({
        'savedEvents': FieldValue.arrayRemove([eventId])
      });
    } else {
      await usersCollection
          .doc(AuthService().getCurrentFirebaseUser()?.uid)
          .update({
        'savedEvents': FieldValue.arrayUnion([eventId])
      });
    }
  }

  Future<void> followArtist(AppUser artist) async {
    final currentUser = StateService().currentUser!;
    // Currently not allowed
    if (artist.type == UserType.base || artist.type == UserType.guest) return;
    if (currentUser.savedArtists.contains(artist.uid)) {
      await usersCollection.doc(currentUser.uid).update({
        'savedArtists': FieldValue.arrayRemove([artist.uid])
      });

      await usersCollection.doc(artist.uid).update({
        'follower': FieldValue.arrayRemove([currentUser.uid])
      });
    } else {
      await usersCollection.doc(currentUser.uid).update({
        'savedArtists': FieldValue.arrayUnion([artist.uid])
      });

      await usersCollection.doc(artist.uid).update({
        'follower': FieldValue.arrayUnion([currentUser.uid])
      });
    }
  }

  Future<void> followHost(AppUser user) async {
    final currentUser = StateService().currentUser!;
    // Currently not allowed
    if (user.type == UserType.base || user.type == UserType.guest) return;
    if (currentUser.savedHosts.contains(user.uid)) {
      await usersCollection.doc(currentUser.uid).update({
        'savedHosts': FieldValue.arrayRemove([user.uid])
      });

      await usersCollection.doc(user.uid).update({
        'follower': FieldValue.arrayRemove([currentUser.uid])
      });
    } else {
      await usersCollection.doc(currentUser.uid).update({
        'savedHosts': FieldValue.arrayUnion([user.uid])
      });

      await usersCollection.doc(user.uid).update({
        'follower': FieldValue.arrayUnion([currentUser.uid])
      });
    }
  }

  Future<void> saveMainLocationData(LatLng coordinates) async {
    await usersCollection
        .doc(StateService().currentUser!.uid)
        .update({'mainLocationCoordinates': coordinates.toJson()});
  }

  Future<void> addUserTickets(List<TicketInfo> ticketInfos) async {
    final currentUser = StateService().currentUser!;
    await usersCollection.doc(currentUser.uid).update({
      'allTickets':
          FieldValue.arrayUnion(ticketInfos.map((e) => e.toJson()).toList())
    });
    currentUser.allTickets.addAll(ticketInfos);
    // AuthService().currentUser!.allTickets =
    //     List.from(AuthService().currentUser!.allTickets)..addAll(ticketInfos);
  }
}
