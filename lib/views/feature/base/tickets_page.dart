import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/ticket_info.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:event_finder/widgets/ticket_tile.dart';
import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage>
    with SingleTickerProviderStateMixin {
  List<TicketInfo> currentTickets = [];
  List<TicketInfo> pastTickets = [];
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _fillCurrentTickets();
    _fillPastTickets();
  }

  void _fillCurrentTickets() {
    final AppUser currentUser = StateService().currentUser!;
    final now = DateTime.now();
    var startOfDay = DateTime(now.year, now.month, now.day);
    for (var ticketInfo in currentUser.allTickets) {
      if (ticketInfo.endDate != null) {
        if (ticketInfo.endDate!.isAfter(now)) {
          currentTickets.add(ticketInfo);
        }
      } else {
        if (ticketInfo.startDate.isAfter(startOfDay)) {
          currentTickets.add(ticketInfo);
        }
      }
    }
  }

  void _fillPastTickets() {
    final AppUser currentUser = StateService().currentUser!;
    pastTickets = currentUser.allTickets.where((element) {
      if (element.endDate != null) {
        return DateTime.now().isAfter(element.endDate!);
      } else {
        final now = DateTime.now();
        late DateTime endDate;
        if (now.hour >= 12) {
          endDate = DateTime(now.year, now.month, now.day + 1, now.hour - 12);
        } else {
          endDate = DateTime(now.year, now.month, now.day, now.hour + 12);
        }
        return endDate.isAfter(element.startDate);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: primaryGradient,
        ),
        child: SafeArea(
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
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    'Meine Tickets',
                    style: TextStyle(fontSize: 24),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () async {
                        currentTickets = [];
                        pastTickets = [];
                        StateService().currentUser =
                            await UserDocService().getCurrentUserData();
                        _fillCurrentTickets();
                        _fillPastTickets();
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Aktuell',
                  ),
                  Tab(text: 'Vergangen'),
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  if (currentTickets.isEmpty)
                    const Center(
                      child: Text('Keine Tickets'),
                    ),
                  if (currentTickets.isNotEmpty)
                    ListView.builder(
                      itemCount: currentTickets.length,
                      prototypeItem: const SizedBox(
                        height: 110,
                      ),
                      itemBuilder: (context, index) {
                        return TicketTile(
                          ticketInfo: currentTickets[index],
                        );
                      },
                    ),
                  ListView.builder(
                    itemCount: pastTickets.length,
                    prototypeItem: const SizedBox(
                      height: 110,
                    ),
                    itemBuilder: (context, index) {
                      return TicketTile(
                        ticketInfo: pastTickets[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
