import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
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
  bool _mapLoading = false;
  late Future<String> _hostImageUrlFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Row(
                children: [
                  Opacity(
                    opacity: StateService().currentUser!.type == UserType.guest
                        ? 0.2
                        : 1,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: GestureDetector(
                        onTap: () {
                          if (StateService().currentUser!.type ==
                              UserType.guest) {
                            return;
                          }
                          setState(() {
                            _today = !_today;
                          });
                        },
                        child: Chip(
                          backgroundColor: _today ? Colors.teal : null,
                          label: const Text('Heute'),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Opacity(
                      opacity:
                          StateService().currentUser!.type == UserType.guest
                              ? 0.2
                              : 1,
                      child: StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          if (_mapLoading) {
                            return Container(
                                margin: const EdgeInsets.only(right: 16),
                                width: 15,
                                height: 15,
                                child: const CircularProgressIndicator(
                                    color: primaryWhite));
                          } else {
                            return IconButton(
                              icon: const Icon(
                                Icons.map,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (StateService().currentUser!.type ==
                                    UserType.guest) {
                                  return;
                                }
                                setState(() {
                                  _mapLoading = true;
                                });
                                StateService().currentUserLocation =
                                    await Geolocator.getCurrentPosition();
                                setState(() {
                                  _mapLoading = false;
                                });
                                if (mounted) {
                                  Navigator.pushNamed(context, 'maps_page');
                                }
                              },
                            );
                          }
                        },
                      )),
                  Opacity(
                    opacity: StateService().currentUser!.type == UserType.guest
                        ? 0.2
                        : 1,
                    child: IconButton(
                      icon: Badge(
                        isLabelVisible:
                            StateService().selectedGenres.isNotEmpty,
                        label: Text('${StateService().selectedGenres.length}'),
                        child: const Icon(
                          Icons.filter_alt,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (StateService().currentUser!.type ==
                            UserType.guest) {
                          return;
                        }
                        _showFiltersSheet();
                      },
                    ),
                  )
                ],
              ),
              const Divider(
                height: 30,
              ),
              Expanded(
                child: FirestoreListView<Event>(
                  emptyBuilder: (context) {
                    return const Center(
                      child: Text('Keine Events'),
                    );
                  },
                  query: _getQuery(),
                  itemBuilder: (context, snapshot) {
                    final event = snapshot.data();
                    _hostImageUrlFuture =
                        StorageService().getUserImageUrl(event.creatorId);
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            children: [
                              FutureBuilder(
                                  future: _hostImageUrlFuture,
                                  builder: (context, snapshot) {
                                    return Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final host = await UserDocService()
                                                .getUserData(event.creatorId);
                                            if (host == null) return;
                                            host.imageUrl = snapshot.data;
                                            StateService().lastSelectedHost =
                                                host;
                                            if (mounted) {
                                              Navigator.pushNamed(
                                                  context, 'host_page');
                                            }
                                          },
                                          child: CircleAvatar(
                                            radius: 18,
                                            backgroundImage:
                                                snapshot.connectionState ==
                                                        ConnectionState.waiting
                                                    ? null
                                                    : NetworkImage(
                                                        snapshot.data ?? ''),
                                            child: snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? const SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final host = await UserDocService()
                                                .getUserData(event.creatorId);
                                            if (host == null) return;
                                            host.imageUrl = snapshot.data;
                                            StateService().lastSelectedHost =
                                                host;
                                            if (mounted) {
                                              Navigator.pushNamed(
                                                  context, 'host_page');
                                            }
                                          },
                                          child: Text(
                                            event.creatorName,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                              const Spacer(),
                              StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return IconButton(
                                    onPressed: () async {
                                      await UserDocService()
                                          .saveEvent(event.uid);
                                      setState(() {
                                        StateService()
                                            .toggleSavedEvent(event.uid);
                                      });
                                    },
                                    icon: StateService()
                                            .currentUser!
                                            .savedEvents
                                            .contains(event.uid)
                                        ? const Icon(Icons.bookmark)
                                        : const Icon(Icons.bookmark_border));
                              }),
                            ],
                          ),
                        ),
                        EventCard(event: snapshot.data()),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    );
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
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    var query = EventDocService()
        .eventsCollection
        .orderBy('date')
        .where('date', isGreaterThanOrEqualTo: startOfDay);

    if (_today) {
      final endOfDay = DateTime(now.year, now.month, now.day + 1);
      query = query.where('date', isLessThanOrEqualTo: endOfDay);
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
