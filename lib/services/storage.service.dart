import 'dart:html';
import 'dart:io';

import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  factory StorageService() {
    return _singleton;
  }
  StorageService._internal();
  static final StorageService _singleton = StorageService._internal();
  final storage = FirebaseStorage.instance;

  Future<void> saveEventImageToStorage(String eventId, File file) async {
    await storage
        .ref('${AuthService().getCurrentFirebaseUser()!.uid}/events/$eventId')
        .putBlob(file);
  }

  Future<String> getEventImageUrl({required Event event}) async {
    int numOfRetries = 0;
    if (numOfRetries == 5) {
      throw Exception('File does not exist');
    }
    final ref = storage.ref().child('${event.creatorId}/events/${event.uid}');
    return await ref.getDownloadURL().then((downloadUrl) async {
      return downloadUrl;
    }, onError: (error, _) async {
      // Catching the error here is on purpose by design, reason for it is as follows:
      // The FirestoreListView Widget is a live stream, and our event documents
      // get created first which causes the stream to refresh before the image file
      // was uploaded. getDownloadURL will not throw so we have to explicitly catch
      // the 'error' and wait until the image file has been stored
      await Future.delayed(const Duration(milliseconds: 500));
      numOfRetries++;
      return await getEventImageUrl(event: event);
    });
  }

  Future<void> saveProfileImageToStorage(File file) async {
    await storage
        .ref('profile/${AuthService().getCurrentFirebaseUser()!.uid}/image')
        .putBlob(file);
  }

  Future<String> getProfileImageUrl() async {
    final ref = storage
        .ref()
        .child('profile/${AuthService().getCurrentFirebaseUser()!.uid}/image');
    return await ref.getDownloadURL();
  }

  Future<String> getUserImageUrl(String uid) async {
    final ref = storage.ref().child('profile/$uid/image');
    return await ref.getDownloadURL();
  }
}
