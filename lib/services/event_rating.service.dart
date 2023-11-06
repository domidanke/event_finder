import 'package:event_finder/models/event.dart';

class EventRatingService {
  factory EventRatingService() {
    return _singleton;
  }
  EventRatingService._internal();
  static final EventRatingService _singleton = EventRatingService._internal();

  Event? selectedEventToRate;
}
