import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/views/feature/shared/genre_picker.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ArtistSearch extends StatefulWidget {
  const ArtistSearch({super.key});

  @override
  State<ArtistSearch> createState() => _ArtistSearchState();
}

class _ArtistSearchState extends State<ArtistSearch> {
  late Future<String> _imageUrl;
  final _artistSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  IconButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {});
                      },
                      icon: const Icon(Icons.search)),
                  IconButton(
                    icon: Badge(
                      isLabelVisible: StateService().selectedGenres.isNotEmpty,
                      label: Text('${StateService().selectedGenres.length}'),
                      child: const Icon(
                        Icons.filter_alt,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _showFiltersSheet();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
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

                  /// This is used twice, also in saved artists page TODO: merge into one widget
                  return GestureDetector(
                    onTap: () {
                      StateService().lastSelectedArtist = artist;
                      Navigator.pushNamed(context, 'artist_page');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
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
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 88),
                            child: Row(
                              children: artist.genres
                                  .map((e) => Card(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 8),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
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
