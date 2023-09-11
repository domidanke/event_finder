import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/search_page.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/top_genres.dart';
import 'package:event_finder/widgets/user_search_field.dart';
import 'package:event_finder/widgets/user_tile.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<SearchPageService>(context).searchText;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                child: Row(
                  children: const [
                    Expanded(
                        child: UserSearchField(
                      hintText: 'Künstler oder Hosts',
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              if (SearchPageService().searchText.isEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TopGenres(onGenreSelected: (String genre) {
                      StateService().lastSelectedGenre = genre;
                      Navigator.pushNamed(context, 'genre_search_result');
                    }),
                  ),
                ),
              if (SearchPageService().searchText.isNotEmpty)
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
    );
  }

  Query<AppUser> _getQuery() {
    return UserDocService()
        .usersCollection
        .where('displayName',
            isGreaterThanOrEqualTo: SearchPageService().searchText)
        .where('displayName', isLessThan: '${SearchPageService().searchText}z')
        .orderBy('displayName');
  }
}
