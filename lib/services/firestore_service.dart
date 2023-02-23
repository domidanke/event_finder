import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreService extends ChangeNotifier {
  factory FirestoreService() {
    return _singleton;
  }
  FirestoreService._internal();
  static final FirestoreService _singleton = FirestoreService._internal();

  static final db = FirebaseFirestore.instance;

  bool _loginLoading = false;
  bool _registerLoading = false;

  bool get loginLoading => _loginLoading;
  bool get registerLoading => _registerLoading;

  set loginLoading(bool loading) {
    _loginLoading = loading;
    notifyListeners();
  }

  set registerLoading(bool loading) {
    _registerLoading = loading;
    notifyListeners();
  }
}
