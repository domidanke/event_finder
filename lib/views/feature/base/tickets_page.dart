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
    var tickets = StateService().currentUser!.allTickets;
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
        itemCount: tickets.length,
        prototypeItem: ListTile(
          title: Text(tickets.first.eventTitle),
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tickets[index].eventTitle),
            subtitle:
                Text(tickets[index].eventDate.toString().substring(0, 16)),
            trailing: IconButton(
              onPressed: () {
                StateService().lastSelectedTicket = tickets[index];
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
