import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/qr_code.dart';
import 'package:flutter/material.dart';

class TicketDetailsPage extends StatelessWidget {
  TicketDetailsPage({Key? key}) : super(key: key);

  final ticketInfo = StateService().lastSelectedTicket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: QrCode(
            size: 250,
            data: ticketInfo!.id,
          ),
        ),
      ),
    );
  }
}
