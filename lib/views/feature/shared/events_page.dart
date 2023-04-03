import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/consts.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
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
  String? _selectedGenre;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('REBUILD ROOT');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
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
          IconButton(
            icon: const Icon(
              Icons.filter_alt,
              color: Colors.white,
            ),
            onPressed: () {
              _showFiltersSheet();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _today = !_today;
                      });
                    },
                    child: Chip(
                      backgroundColor: _today ? primaryColor : null,
                      label: const Text('Heute'),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (_selectedGenre != null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGenre = null;
                        });
                      },
                      child: Chip(
                        label: Row(
                          children: [
                            Text(_selectedGenre!),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.cancel,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Expanded(
                flex: 10,
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
            ],
          ),
        ),
      ),
    );
  }

  Query<Event> _getQuery() {
    print('GENRE: $_selectedGenre');
    var query = EventDocService().eventsCollection.orderBy('date');

    if (_today) {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day + 1);
      query = query
          .where('date', isLessThanOrEqualTo: endOfDay)
          .where('date', isGreaterThanOrEqualTo: startOfDay);
    }

    if (_selectedGenre != null) {
      query = query.where('genre', isEqualTo: _selectedGenre);
    }

    return query;
  }

  void _showFiltersSheet() {
    _selectedGenre = _selectedGenre ?? genres.first;
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton<String>(
              value: _selectedGenre,
              icon: const Icon(Icons.arrow_drop_down_rounded),
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value!;
                });
                Navigator.pop(context);
              },
              items: genres.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
