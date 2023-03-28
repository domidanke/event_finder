import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/models/ticket_info.dart';
import 'package:flutter/material.dart';

class StateService extends ChangeNotifier {
  factory StateService() {
    return _singleton;
  }
  StateService._internal();
  static final StateService _singleton = StateService._internal();

  AppUser? currentUser;

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

  TicketInfo? _lastSelectedTicket;
  TicketInfo? get lastSelectedTicket => _lastSelectedTicket;

  set lastSelectedTicket(TicketInfo? ticketInfo) {
    _lastSelectedTicket = ticketInfo;
    notifyListeners();
  }

  NewEvent newEvent = NewEvent();

  /// TODO: Move to separate User State service class
  void toggleSavedEvent(String eventUid) {
    if (currentUser!.savedEvents.contains(eventUid)) {
      currentUser!.savedEvents.remove(eventUid);
    } else {
      currentUser!.savedEvents.add(eventUid);
    }
  }

  /// TODO: Move to separate User State service class
  void toggleSavedArtist(String artistUid) {
    if (currentUser!.savedArtists.contains(artistUid)) {
      currentUser!.savedArtists.remove(artistUid);
    } else {
      currentUser!.savedArtists.add(artistUid);
    }
    // This is currently used in saved artists; when popping the screen,
    // the saved artists need to know about the unfollow change and disappear
    notifyListeners();
  }

  /// TODO: Move to separate User State service class
  void toggleSavedHost(String hostUid) {
    if (currentUser!.savedHosts.contains(hostUid)) {
      currentUser!.savedHosts.remove(hostUid);
    } else {
      currentUser!.savedHosts.add(hostUid);
    }
    notifyListeners();
  }

  /// TODO: Move to separate User State service class
  bool isProfileComplete() {
    return currentUser!.mainLocationCoordinates.latitude != 0 &&
        currentUser!.mainLocationCoordinates.longitude != 0 &&
        currentUser!.displayName.isNotEmpty;
  }

  void addTickets(List<TicketInfo> ticketInfos) {
    currentUser!.allTickets.addAll(ticketInfos);
    notifyListeners();
  }
}
