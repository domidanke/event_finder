import 'package:flutter/material.dart';

class EventsPageService extends ChangeNotifier {
  factory EventsPageService() {
    return _singleton;
  }
  EventsPageService._internal();
  static final EventsPageService _singleton = EventsPageService._internal();

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }
}
