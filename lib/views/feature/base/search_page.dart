import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/artist_tile.dart';
import 'package:event_finder/widgets/top_genres.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

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
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (text) {
                        setState(() {});
                      },
                      controller: _searchController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Suche Künstler oder Hosts',
                          suffixIcon: Icon(
                            Icons.search,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            if (_searchController.text.isEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TopGenres(onGenreSelected: (String genre) {
                    StateService().lastSelectedGenre = genre;
                    Navigator.pushNamed(context, 'genre_search_result');
                  }),
                ),
              ),
            if (_searchController.text.isNotEmpty)
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
    return UserDocService()
        .usersCollection
        .where('displayName', isGreaterThanOrEqualTo: _searchController.text)
        .where('displayName', isLessThan: '${_searchController.text}z')
        .orderBy('displayName');
  }
}
