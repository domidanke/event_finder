import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/event_card.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class SavedEventsPage extends StatefulWidget {
  const SavedEventsPage({super.key});

  @override
  State<SavedEventsPage> createState() => _SavedEventsPageState();
}

class _SavedEventsPageState extends State<SavedEventsPage> {
  late Future<String> _hostImageUrlFuture;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                ],
              ),
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
                  Event event = snapshot.data();
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
                                          backgroundImage: snapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting
                                              ? null
                                              : NetworkImage(snapshot.data!),
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
                                          style: const TextStyle(fontSize: 12),
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
                                    await UserDocService().saveEvent(event.uid);
                                    setState(() {
                                      StateService()
                                          .toggleSavedEvent(event.uid);
                                    });
                                  },
                                  icon: StateService()
                                          .currentUser!
                                          .savedEvents
                                          .contains(event.uid)
                                      ? const Icon(
                                          Icons.bookmark,
                                          color: secondaryColor,
                                        )
                                      : const Icon(Icons.bookmark_border));
                            }),
                          ],
                        ),
                      ),
                      EventCard(event: snapshot.data()),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Query<Event> _getQuery() {
    return EventDocService().eventsCollection.where(FieldPath.documentId,
        whereIn: StateService().currentUser!.savedEvents);
  }
}
