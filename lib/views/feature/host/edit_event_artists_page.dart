import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class EditEventArtistsPage extends StatefulWidget {
  const EditEventArtistsPage({super.key});

  @override
  State<EditEventArtistsPage> createState() => _EditEventArtistsPageState();
}

class _EditEventArtistsPageState extends State<EditEventArtistsPage> {
  late Future<String> _imageUrl;
  final _artistSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final event = StateService().lastSelectedEvent!;
    final artistsBeforeEdit = List<String>.from(event.artists);
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
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {});
                        },
                        child: const Icon(Icons.search)),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 9,
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
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: StatefulBuilder(
                            builder: (BuildContext context,
                                void Function(void Function()) setState) {
                              return Checkbox(
                                  value: event.artists.contains(artist.uid),
                                  onChanged: (v) {
                                    setState(() {
                                      event.artists.contains(artist.uid)
                                          ? event.artists.remove(artist.uid)
                                          : event.artists.add(artist.uid);
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
                                      backgroundImage: snapshot
                                                  .connectionState ==
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
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : null,
                                    );
                                  }),
                              title: Text(artist.displayName),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      event.artists = artistsBeforeEdit;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () {
                    /// TODO: Add function that checks if arrays are identical (== not working)
                    EventDocService().updateEventArtists();
                    Navigator.pop(context);
                  },
                  child: const Text('Speichern'),
                ),
              ],
            ),
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
