import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/genre_picker.dart';
import 'package:event_finder/widgets/date_selection_scroller.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/events_page.service.dart';
import '../shared/event_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late Future<String> _hostImageUrlFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<EventsPageService>(context).selectedDate;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Opacity(
                      opacity:
                          StateService().currentUser!.type == UserType.guest
                              ? 0.2
                              : 1,
                      child: IconButton(
                        icon: Badge(
                          isLabelVisible:
                              StateService().selectedGenres.isNotEmpty,
                          label:
                              Text('${StateService().selectedGenres.length}'),
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
                const DateSelectionScroller(),
                const Divider(
                  height: 10,
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
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                final host =
                                                    await UserDocService()
                                                        .getUserData(
                                                            event.creatorId);
                                                if (host == null) return;
                                                host.imageUrl = snapshot.data;
                                                StateService()
                                                    .lastSelectedHost = host;
                                                if (mounted) {
                                                  Navigator.pushNamed(
                                                      context, 'host_page');
                                                }
                                              },
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundImage: snapshot
                                                            .connectionState ==
                                                        ConnectionState.waiting
                                                    ? null
                                                    : NetworkImage(
                                                        snapshot.data ?? ''),
                                                child: snapshot
                                                            .connectionState ==
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
                                                final host =
                                                    await UserDocService()
                                                        .getUserData(
                                                            event.creatorId);
                                                if (host == null) return;
                                                host.imageUrl = snapshot.data;
                                                StateService()
                                                    .lastSelectedHost = host;
                                                if (mounted) {
                                                  Navigator.pushNamed(
                                                      context, 'host_page');
                                                }
                                              },
                                              child: Text(
                                                event.creatorName,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
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
      ),
    );
  }

  Query<Event> _getQuery() {
    final now = DateTime.now();
    var startOfDay = DateTime(now.year, now.month, now.day);
    var query = EventDocService().eventsCollection.orderBy('startDate');

    if (EventsPageService().selectedDate != null) {
      startOfDay = EventsPageService().selectedDate!;
      final endOfDay =
          DateTime(startOfDay.year, startOfDay.month, startOfDay.day + 1);
      query = query.where('startDate', isLessThanOrEqualTo: endOfDay);
    }

    query = query.where('startDate', isGreaterThanOrEqualTo: startOfDay);

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
