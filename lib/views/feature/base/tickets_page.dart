import 'package:event_finder/services/state.service.dart';
import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var allTickets = StateService().currentUser!.allTickets;
    var usedTickets = StateService().currentUser!.usedTickets;
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
        itemCount: allTickets.length,
        prototypeItem: ListTile(
          title: Text(allTickets.first.eventTitle),
        ),
        itemBuilder: (context, index) {
          var ticketNumber = allTickets[index].id.split('_')[3];
          return ListTile(
            title: Text(
                '${allTickets[index].eventTitle} ($ticketNumber) ${usedTickets.contains(allTickets[index].id) ? '-- Eingeloest' : ''}'),
            subtitle:
                Text(allTickets[index].eventDate.toString().substring(0, 16)),
            trailing: IconButton(
              onPressed: () {
                StateService().lastSelectedTicket = allTickets[index];
                Navigator.pushNamed(context, 'ticket_details');
              },
              icon: const Icon(Icons.qr_code),
            ),
          );
        },
      )),
    );
  }
}
