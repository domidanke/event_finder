import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/kk_back_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    return RefreshIndicator(
      onRefresh: () async {
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
                itemCount: currentUser.allTickets.length,
                prototypeItem: ListTile(
                  title: Text(currentUser.allTickets.first.eventTitle),
                ),
                itemBuilder: (context, index) {
                  var ticketNumber =
                      currentUser.allTickets[index].id.split('_')[3];
                  return ListTile(
                    title: Text(
                        '${currentUser.allTickets[index].eventTitle} ($ticketNumber) ${currentUser.usedTickets.contains(currentUser.allTickets[index].id) ? '-- Eingeloest' : ''}'),
                    subtitle: Text(currentUser.allTickets[index].eventDate
                        .toString()
                        .substring(0, 16)),
                    trailing: IconButton(
                      onPressed: () {
                        StateService().lastSelectedTicket =
                            currentUser.allTickets[index];
                        Navigator.pushNamed(context, 'ticket_details');
                      },
                      icon: const Icon(Icons.qr_code),
                    ),
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
