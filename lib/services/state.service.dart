import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/models/location_data.dart';
import 'package:event_finder/models/ticket_info.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class StateService extends ChangeNotifier {
  factory StateService() {
    return _singleton;
  }
  StateService._internal();
  static final StateService _singleton = StateService._internal();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  set currentUser(AppUser? user) {
    _currentUser = user;
    notifyListeners();
  }

  void setCurrentUserDisplayName(String displayName) async {
    currentUser!.displayName = displayName;
    notifyListeners();
  }

  void setCurrentUserGenres(List<String> genres) async {
    currentUser!.genres = List.from(genres);
    notifyListeners();
  }

  Future<void> refreshCurrentUserImageUrl() async {
    currentUser!.imageUrl = await StorageService().getProfileImageUrl();
    notifyListeners();
  }

  final List<String> _selectedGenres = [];
  List<String> get selectedGenres => _selectedGenres;
  toggleGenre(String genre) {
    if (_selectedGenres.contains(genre)) {
      _selectedGenres.remove(genre);
    } else {
      _selectedGenres.add(genre);
    }
  }

  resetSelectedGenres() {
    _selectedGenres.clear();
  }

  /// This method ensures that a user gets set properly inside the
  /// auth startup page. We don't want a provider rebuild on init
  set setCurrentUserSilent(AppUser user) {
    _currentUser = user;
  }

  Future<void> getCurrentUserSilent() async {
    _currentUser = await UserDocService().getCurrentUserData();
  }

  /// This method ensures that the current user gets set to null
  /// when logging out. We don't want a provider rebuild in the background
  resetCurrentUserSilent() {
    _currentUser = null;
  }

  set currentUserMainLocation(LocationData coordinates) {
    _currentUser!.mainLocation = coordinates;
    notifyListeners();
  }

  Position? _currentUserLocation;
  Position? get currentUserLocation => _currentUserLocation;

  set currentUserLocation(Position? location) {
    _currentUserLocation = location;
    notifyListeners();
  }

  Event? _lastSelectedEvent;
  Event? get lastSelectedEvent => _lastSelectedEvent;

  set lastSelectedEvent(Event? event) {
    _lastSelectedEvent = event;
    notifyListeners();
  }

  set lastSelectedEventDetails(String newDetails) {
    _lastSelectedEvent!.details = newDetails;
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
    notifyListeners();
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
    return currentUser!.mainLocation.geoHash.isNotEmpty &&
        currentUser!.displayName.isNotEmpty;
  }

  void addTickets(List<TicketInfo> ticketInfos) {
    currentUser!.allTickets.addAll(ticketInfos);
    notifyListeners();
  }
}
