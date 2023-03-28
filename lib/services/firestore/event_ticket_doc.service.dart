import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/ticket_info.dart';

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

  Future<void> addTicketDocument(String eventId) async {
    await eventTicketsCollection
        .doc(eventId)
        .set(EventTicket(allTickets: [], usedTickets: []));
  }

  Future<void> addTicketsToEvent(
      List<TicketInfo> ticketInfos, String eventId) async {
    var ids = ticketInfos.map((e) => e.id).toList();
    await eventTicketsCollection
        .doc(eventId)
        .update({'allTickets': FieldValue.arrayUnion(ids)});
  }
}
