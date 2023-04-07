import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:event_finder/views/feature/shared/genre_picker.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../theme/theme.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool _today = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Opacity(
            opacity:
                StateService().currentUser!.type == UserType.guest ? 0.2 : 1,
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              child: GestureDetector(
                onTap: () {
                  if (StateService().currentUser!.type == UserType.guest) {
                    return;
                  }
                  setState(() {
                    _today = !_today;
                  });
                },
                child: Chip(
                  backgroundColor: _today ? primaryColor : null,
                  label: const Text('Heute'),
                ),
              ),
            ),
          ),
          const Spacer(),
          Opacity(
            opacity:
                StateService().currentUser!.type == UserType.guest ? 0.2 : 1,
            child: IconButton(
              icon: const Icon(
                Icons.map,
                color: Colors.white,
              ),
              onPressed: () async {
                if (StateService().currentUser!.type == UserType.guest) return;
                StateService().currentUserLocation =
                    await Geolocator.getCurrentPosition();
                if (mounted) Navigator.pushNamed(context, 'maps_page');
              },
            ),
          ),
          Opacity(
            opacity:
                StateService().currentUser!.type == UserType.guest ? 0.2 : 1,
            child: IconButton(
              icon: const Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
              onPressed: () {
                if (StateService().currentUser!.type == UserType.guest) return;
                _showFiltersSheet();
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FirestoreListView<Event>(
            emptyBuilder: (context) {
              return const Center(
                child: Text('Keine Events'),
              );
            },
            query: _getQuery(),
            itemBuilder: (context, snapshot) {
              return EventCard(event: snapshot.data());
            },
          ),
        ),
      ),
    );
  }

  Query<Event> _getQuery() {
    var query = EventDocService().eventsCollection.orderBy('date');

    if (_today) {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day + 1);
      query = query
          .where('date', isLessThanOrEqualTo: endOfDay)
          .where('date', isGreaterThanOrEqualTo: startOfDay);
    }

    if (StateService().selectedGenres.isNotEmpty) {
      query = query.where('genres',
          arrayContainsAny: StateService().selectedGenres);
    }

    return query;
  }

  void _showFiltersSheet() {
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const GenrePicker(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KKButton(
                    onPressed: () {
                      StateService().resetSelectedGenres();
                      Navigator.pop(context);
                      setState(() {});
                    },
                    buttonText: 'Reset'),
                KKButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    buttonText: 'Anwenden')
              ],
            )
          ],
        ),
      ),
    );
  }
}
