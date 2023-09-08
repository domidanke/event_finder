import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/event_ticket.dart';

class EventTicketDocService {
  factory EventTicketDocService() {
    return _singleton;
  }
  EventTicketDocService._internal();
  static final EventTicketDocService _singleton =
      EventTicketDocService._internal();

  static final db = FirebaseFirestore.instance;

  final eventTicketsCollection =
      db.collection('EventTickets').withConverter<EventTicket>(
            fromFirestore: (snapshot, _) {
              if (snapshot.exists) {
                return EventTicket.fromJson(snapshot.data()!);
              }
              throw Exception('RIP');
            },
            toFirestore: (eventTicket, _) => eventTicket.toJson(),
          );
}
