import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/views/feature/shared/genre_picker.dart';
import 'package:event_finder/widgets/artist_tile.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ArtistSearch extends StatefulWidget {
  const ArtistSearch({super.key});

  @override
  State<ArtistSearch> createState() => _ArtistSearchState();
}

class _ArtistSearchState extends State<ArtistSearch> {
  final _artistSearchController = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        setState(() {});
                      },
                      controller: _artistSearchController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Suche',
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.teal,
                          )),
                    ),
                  ),
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
            if (_artistSearchController.text.isEmpty &&
                StateService().selectedGenres.isEmpty)
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Suche nach Namen oder Filter nach Genres',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ),
              ),
            if (_artistSearchController.text.isNotEmpty ||
                StateService().selectedGenres.isNotEmpty)
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
                    return UserTile(user: snapshot.data());
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
      isDismissible: false,
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
                    buttonText: 'Abbrechen'),
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
