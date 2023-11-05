import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/ticket_info.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../models/rating_data.dart';

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
    await usersCollection
        .doc(StateService().currentUser!.uid)
        .update({'type': UserType.base});
  }

  Future<AppUser?> getCurrentUserData() async {
    if (AuthService().getCurrentFirebaseUser() == null) return null;
    if (AuthService().getCurrentFirebaseUser()!.isAnonymous) {
      return AppUser(displayName: 'Gast', type: UserType.guest);
    }
    final doc = await usersCollection
        .doc(AuthService().getCurrentFirebaseUser()!.uid)
        .get();
    return doc.data();
  }

  Future<AppUser?> getUserData(String userId) async {
    final doc = await usersCollection.doc(userId).get();
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

  Future<void> toggleFollowArtist(AppUser artist) async {
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

  Future<void> toggleFollowHost(AppUser user) async {
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

  Future<void> saveMainLocationData(GeoFirePoint geoFirePoint) async {
    await usersCollection
        .doc(StateService().currentUser!.uid)
        .update({'mainLocation': geoFirePoint.data});
  }

  Future<void> addUserTickets(TicketInfo ticketInfo) async {
    final currentUser = StateService().currentUser!;
    await usersCollection.doc(currentUser.uid).update({
      'allTickets': FieldValue.arrayUnion([ticketInfo.toJson()])
    });
  }

  Future<void> redeemUserTickets(String qrCodeId) async {
    // Extract user ID from qr code id
    var userId = qrCodeId.split('_')[0];
    var eventId = qrCodeId.split('_')[3];
    await usersCollection.doc(userId).update({
      'usedTickets': FieldValue.arrayUnion([qrCodeId])
    });
    await usersCollection.doc(userId).update({
      'eventsToBeRated': FieldValue.arrayUnion([eventId])
    });
  }

  Future<void> updateDisplayName(String newDisplayName) async {
    await usersCollection
        .doc(StateService().currentUser!.uid)
        .update({'displayName': newDisplayName});
  }

  Future<void> updateArtistGenres() async {
    await usersCollection
        .doc(StateService().currentUser!.uid)
        .update({'genres': StateService().selectedGenres});
  }

  Future<void> acceptTerms() async {
    await usersCollection
        .doc(StateService().currentUser!.uid)
        .update({'termsAcceptedDate': DateTime.now()});
    StateService().currentUser = null;
  }

  Future<void> rateArtists(Map<String, int> artistRatings) async {
    for (var rating in artistRatings.entries) {
      final snapshot = await usersCollection.doc(rating.key).get();
      final artist = snapshot.data()!;
      if (artist.ratingData == null) {
        await usersCollection.doc(rating.key).update({
          'ratingData':
              RatingData(totalRating: rating.value, numOfRatings: 1).toJson()
        });
      } else {
        await usersCollection.doc(rating.key).update({
          'ratingData': RatingData(
                  totalRating: artist.ratingData!.totalRating + rating.value,
                  numOfRatings: artist.ratingData!.numOfRatings + 1)
              .toJson()
        });
      }
    }
  }

  Future<void> finishRatingForUser(String eventId) async {
    final currentUser = StateService().currentUser!;
    await usersCollection.doc(currentUser.uid).update({
      'eventsToBeRated': FieldValue.arrayRemove([eventId])
    });
    StateService().currentUser = await getUserData(currentUser.uid);
  }
}
