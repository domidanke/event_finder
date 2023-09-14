import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/shared/genre_picker.dart';
import 'package:event_finder/widgets/custom_button.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:event_finder/widgets/user_tile.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/search.service.dart';
import '../../../widgets/user_search_field.dart';

class ArtistSearch extends StatefulWidget {
  const ArtistSearch({super.key});

  @override
  State<ArtistSearch> createState() => _ArtistSearchState();
}

class _ArtistSearchState extends State<ArtistSearch> {
  @override
  Widget build(BuildContext context) {
    Provider.of<SearchService>(context).searchText;
    return WillPopScope(
      onWillPop: () async {
        SearchService().searchText = '';
        StateService().selectedGenres.clear();
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: primaryGradient),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CustomIconButton(
                        onPressed: () {
                          SearchService().searchText = '';
                          StateService().selectedGenres.clear();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Expanded(
                          child: UserSearchField(
                        hintText: 'Künstler',
                      )),
                      IconButton(
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
                          _showFiltersSheet();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (SearchService().searchText.isEmpty &&
                    StateService().selectedGenres.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Suche nach Namen oder Filter nach Genres',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                if (SearchService().searchText.isNotEmpty ||
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
    if (SearchService().searchText.isNotEmpty) {
      query = query
          .where('displayName',
              isGreaterThanOrEqualTo: SearchService().searchText)
          .where('displayName', isLessThan: '${SearchService().searchText}z');
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
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 250, child: GenrePicker()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                    onPressed: () {
                      StateService().resetSelectedGenres();
                      Navigator.pop(context);
                      setState(() {});
                    },
                    buttonText: 'Abbrechen'),
                CustomButton(
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
