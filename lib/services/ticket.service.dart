import 'package:event_finder/services/state.service.dart';
import 'package:flutter/material.dart';

import '../models/ticket_info.dart';

class TicketService extends ChangeNotifier {
  factory TicketService() {
    return _singleton;
  }
  TicketService._internal();
  static final TicketService _singleton = TicketService._internal();

  int _numberOfTicketsToBuy = 1;
  int get numberOfTicketsToBuy => _numberOfTicketsToBuy;

  set numberOfTicketsToBuy(int tickets) {
    _numberOfTicketsToBuy = tickets;
    notifyListeners();
  }

  TicketInfo createTicketInfo() {
    final now = DateTime.now();
    var dateAndTime = now.toString().substring(0, 19);
    var event = StateService().lastSelectedEvent!;
    final ticketInfo = TicketInfo(
        ticketQrCodeIds: [],
        userId: StateService().currentUser!.uid,
        eventId: event.uid,
        creatorId: event.creatorId,
        creatorName: event.creatorName,
        eventTitle: event.title,
        startDate: event.startDate,
        endDate: event.endDate,
        purchasedOn: now,
        ticketPrice: event.ticketPrice);
    for (var i = 0; i < TicketService().numberOfTicketsToBuy; i++) {
      ticketInfo.ticketQrCodeIds.add(
          '${StateService().currentUser!.uid}_${event.creatorId}_${event.creatorName}_${event.uid}_${dateAndTime}_${i + 1}/${TicketService().numberOfTicketsToBuy}');
    }
    return ticketInfo;
  }
}
