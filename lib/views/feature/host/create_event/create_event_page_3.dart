import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/alert.service.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/event_ticket_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../models/app_user.dart';
import '../../../../services/state.service.dart';
import '../../../../services/storage/storage.service.dart';
import '../../../../widgets/kk_button.dart';

class CreateEventPage3 extends StatefulWidget {
  const CreateEventPage3({Key? key}) : super(key: key);

  @override
  State<CreateEventPage3> createState() => _CreateEventPage3State();
}

class _CreateEventPage3State extends State<CreateEventPage3> {
  late Future<String> _imageUrl;
  final _artistSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NewEvent newEvent = StateService().newEvent;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _artistSearchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Suche',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          /// Remove annoying keyboard
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {});
                        },
                        child: const Icon(Icons.search)),
                  )
                ],
              ),
            ),
            Expanded(
              child: FirestoreListView<AppUser>(
                emptyBuilder: (context) {
                  return const Center(
                    child: Text('Keine Artists'),
                  );
                },
                query: _getQuery(),
                itemBuilder: (context, snapshot) {
                  final artist = snapshot.data();
                  _imageUrl = StorageService().getUserImageUrl(artist.uid);

                  /// This is used twice, also in saved artists page TODO: merge into one widget
                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: StatefulBuilder(
                          builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return Checkbox(
                                value: newEvent.enlistedArtists
                                    .contains(artist.uid),
                                onChanged: (v) {
                                  setState(() {
                                    newEvent.enlistedArtists
                                            .contains(artist.uid)
                                        ? newEvent.enlistedArtists
                                            .remove(artist.uid)
                                        : newEvent.enlistedArtists
                                            .add(artist.uid);
                                  });
                                });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () {
                            StateService().lastSelectedArtist = artist;
                            Navigator.pushNamed(context, 'artist_page');
                          },
                          child: ListTile(
                            visualDensity: const VisualDensity(vertical: 4),
                            leading: FutureBuilder(
                                future: _imageUrl,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return CircleAvatar(
                                      radius: 30,
                                      backgroundImage: Image.asset(
                                              'assets/images/profile_placeholder.png')
                                          .image,
                                    );
                                  }
                                  artist.imageUrl = snapshot.data;
                                  return CircleAvatar(
                                    radius: 30,
                                    backgroundImage: snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? null
                                        : artist.imageUrl != null
                                            ? NetworkImage(artist.imageUrl!)
                                            : Image.asset(
                                                    'assets/images/profile_placeholder.png')
                                                .image,
                                    child: snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(),
                                          )
                                        : null,
                                  );
                                }),
                            title: Text(artist.displayName),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                KKButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttonText: 'Zurueck',
                ),
                KKButton(
                  onPressed: () async {
                    final event = newEvent.toEvent();
                    final eventId =
                        await EventDocService().addEventDocument(event);
                    await EventTicketDocService().addTicketDocument(eventId);
                    await StorageService()
                        .saveEventImageToStorage(
                            eventId, newEvent.selectedImageFile!)
                        .then((value) => {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Event erstellt.')),
                              ),
                              Navigator.pushNamed(context, 'host_home'),
                            })
                        .catchError((e) {
                      AlertService().showAlert(
                          'Event Bild hochladen fehlgeschlagen',
                          e.toString(),
                          context);
                    });
                  },
                  buttonText: 'Erstellen',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Query<AppUser> _getQuery() {
    var query = UserDocService()
        .usersCollection
        .where(
          'type',
          isEqualTo: 'artist',
        )
        .orderBy('displayName');
    if (_artistSearchController.text.isNotEmpty) {
      query = query
          .where('displayName',
              isGreaterThanOrEqualTo: _artistSearchController.text)
          .where('displayName', isLessThan: '${_artistSearchController.text}z');
    }
    return query;
  }
}
