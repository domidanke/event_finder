import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:flutter/cupertino.dart';

class FirestoreService extends ChangeNotifier {
  factory FirestoreService() {
    return _singleton;
  }
  FirestoreService._internal();
  static final FirestoreService _singleton = FirestoreService._internal();

  static final db = FirebaseFirestore.instance;
  Stream<List<Event>> get entries => _entriesStreamController.stream;
  late final StreamController<List<Event>> _entriesStreamController = StreamController.broadcast();

  void setUserType() async {
    var docSnapshot = await db.collection('Admins').doc(AuthService().getCurrentFirebaseUser()?.uid).get();
    if (docSnapshot.exists) {
      AuthService().currentUsertype = UserType.fromJson(docSnapshot.data()?['type']);
    }
  }

  Future<void> writeEventToFirebase(Event event) async {
    await db.collection('Events').add(<String, String>{
      'title': event.title,
      'date': event.date.toString(),
      'text': event.text,
    });
  }

  void listenForEntries() {
    db.collection('Events')
        .snapshots()
        .listen((event) {
      final entries = event.docs.map((doc) {
        final data = doc.data();
        return Event(
          date: DateTime.parse(data['date'] as String),
          text: data['text'] as String,
          title: data['title'] as String,
        );
      }).toList();

      _entriesStreamController.add(entries);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _entriesStreamController.close();
  }
}
