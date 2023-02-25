import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  factory StorageService() {
    return _singleton;
  }
  StorageService._internal();
  static final StorageService _singleton = StorageService._internal();
  final _storage = FirebaseStorage.instance;

  Future<void> saveToStorage() async {}
}
