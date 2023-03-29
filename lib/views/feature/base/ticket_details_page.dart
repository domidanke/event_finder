import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/qr_code.dart';
import 'package:flutter/material.dart';

class TicketDetailsPage extends StatelessWidget {
  TicketDetailsPage({Key? key}) : super(key: key);

  final ticketInfo = StateService().lastSelectedTicket!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('${ticketInfo.eventTitle} (${ticketInfo.id.split('_')[3]})'),
              Text(ticketInfo.eventDate.toString().substring(0, 16)),
              QrCode(
                size: 250,
                data: ticketInfo.id,
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
