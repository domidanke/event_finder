import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/event.dart';
import 'package:flutter/material.dart';

class StateService extends ChangeNotifier {
  factory StateService() {
    return _singleton;
  }
  StateService._internal();
  static final StateService _singleton = StateService._internal();

  Event? _lastSelectedEvent;
  Event? get lastSelectedEvent => _lastSelectedEvent;

  set lastSelectedEvent(Event? event) {
    _lastSelectedEvent = event;
    notifyListeners();
  }

  AppUser? _lastSelectedArtist;
  AppUser? get lastSelectedArtist => _lastSelectedArtist;

  set lastSelectedArtist(AppUser? artist) {
    _lastSelectedArtist = artist;
    notifyListeners();
  }

  AppUser? _lastSelectedHost;
  AppUser? get lastSelectedHost => _lastSelectedHost;

  set lastSelectedHost(AppUser? host) {
    _lastSelectedHost = host;
    notifyListeners();
  }
}
