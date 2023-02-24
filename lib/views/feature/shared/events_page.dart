import 'dart:math';

import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  @override
  void initState() {
    super.initState();
    FirestoreService().listenForEntries();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService =
        Provider.of<AuthService>(context);
    return Scaffold(
      floatingActionButton: authService.currentUsertype == UserType.host ? FloatingActionButton(onPressed: () {
        Navigator.pushNamed(
            context, 'event_form');
      },
      child: const Icon(Icons.add),) : null,
      backgroundColor: Colors.grey[500],
      body: StreamBuilder<List<Event>>(
        stream: FirestoreService().entries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final allEvents = snapshot.data;
            return ListView.separated(
                //padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  return EventCard(event: allEvents[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: allEvents!.length);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
