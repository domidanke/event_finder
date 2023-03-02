import 'dart:io';

import 'package:event_finder/services/auth.service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  factory StorageService() {
    return _singleton;
  }
  StorageService._internal();
  static final StorageService _singleton = StorageService._internal();
  final storage = FirebaseStorage.instance;

  Future<void> saveEventImageToStorage(String title, File file) async {
    await storage
        .ref('${AuthService().getCurrentFirebaseUser()!.uid}/events/$title')
        .putFile(file);
  }

  Future<String> getEventImageUrl({required String eventTitle}) async {
    final ref = storage.ref().child(
        '${AuthService().getCurrentFirebaseUser()!.uid}/events/$eventTitle');
    return await ref.getDownloadURL();
  }
}
