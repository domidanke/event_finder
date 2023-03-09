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
        .putFile(file);
  }

  Future<String> getEventImageUrl({required Event event}) async {
    // Why is this called twice :(
    print('XXXXXXXXXX downloading for ${event.title}');
    final ref = storage.ref().child('${event.creatorId}/events/${event.uid}');
    return await ref.getDownloadURL();
  }
}
