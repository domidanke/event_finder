import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/qr_code.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_icon_button.dart';

class TicketDetailsPage extends StatelessWidget {
  TicketDetailsPage({Key? key}) : super(key: key);

  final ticketInfo = StateService().lastSelectedTicket!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomIconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Text(
              '${ticketInfo.eventTitle} (${ticketInfo.id.split('_')[3]})',
              style: const TextStyle(fontSize: 28, color: primaryGreen),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              ticketInfo.eventDate.toString().substring(0, 16),
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            QrCode(
              size: 250,
              data: ticketInfo.id,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
