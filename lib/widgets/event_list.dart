import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../models/event.dart';
import '../services/firestore/user_doc.service.dart';
import '../services/state.service.dart';
import '../services/storage/storage.service.dart';
import '../views/feature/shared/event_card.dart';

class EventList extends StatefulWidget {
  const EventList({super.key, required this.query});
  final Query<Event> query;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late Future<String> _hostImageUrlFuture;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: FirestoreListView<Event>(
        emptyBuilder: (context) {
          return const Center(
            child: Text('Keine Events'),
          );
        },
        query: widget.query,
        itemBuilder: (context, snapshot) {
          Event event = snapshot.data();
          _hostImageUrlFuture =
              StorageService().getUserImageUrl(event.creatorId);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: FutureBuilder(
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
                              StateService().lastSelectedHost = host;
                              if (mounted) {
                                Navigator.pushNamed(context, 'host_page');
                              }
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? null
                                  : NetworkImage(snapshot.data!),
                              child: snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(),
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
                              StateService().lastSelectedHost = host;
                              if (mounted) {
                                Navigator.pushNamed(context, 'host_page');
                              }
                            },
                            child: Text(
                              event.creatorName,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              EventCard(event: snapshot.data()),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }
}
