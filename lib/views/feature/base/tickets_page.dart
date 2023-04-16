import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/ticket_info.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/kk_back_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<TicketInfo> unusedTickets = [];

  @override
  void initState() {
    fillUnusedTickets();
    super.initState();
  }

  void fillUnusedTickets() {
    final AppUser currentUser = StateService().currentUser!;
    for (var ticket in currentUser.allTickets) {
      if (!currentUser.usedTickets.contains(ticket.id)) {
        unusedTickets.add(ticket);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    return RefreshIndicator(
      color: primaryColor,
      backgroundColor: primaryWhite,
      onRefresh: () async {
        unusedTickets = [];
        fillUnusedTickets();
        StateService().currentUser =
            await UserDocService().getCurrentUserData();
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  KKBackButton(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: unusedTickets.length,
                prototypeItem: ListTile(
                  title: Text(unusedTickets.first.eventTitle),
                ),
                itemBuilder: (context, index) {
                  var ticketNumber = unusedTickets[index].id.split('_')[3];
                  return ListTile(
                    onTap: () {
                      StateService().lastSelectedTicket = unusedTickets[index];
                      Navigator.pushNamed(context, 'ticket_details');
                    },
                    title: Text(
                        '${unusedTickets[index].eventTitle} ($ticketNumber)'),
                    subtitle: Text(unusedTickets[index]
                        .eventDate
                        .toString()
                        .substring(0, 16)),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bereits eingescannt',
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currentUser.usedTickets.length,
                prototypeItem: ListTile(
                  title: Text(currentUser.allTickets.first.eventTitle),
                ),
                itemBuilder: (context, index) {
                  var ticket = currentUser.allTickets.singleWhere((element) =>
                      element.id == currentUser.usedTickets[index]);
                  var ticketNumber = ticket.id.split('_')[3];
                  return ListTile(
                    onTap: () {
                      StateService().lastSelectedTicket = ticket;
                      Navigator.pushNamed(context, 'ticket_details');
                    },
                    title: Text('${ticket.eventTitle} ($ticketNumber)'),
                    subtitle:
                        Text(ticket.eventDate.toString().substring(0, 16)),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
