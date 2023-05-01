import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/artist_tile.dart';
import 'package:event_finder/widgets/kk_back_button.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedArtistsPage extends StatefulWidget {
  const SavedArtistsPage({super.key});

  @override
  State<SavedArtistsPage> createState() => _SavedArtistsPageState();
}

class _SavedArtistsPageState extends State<SavedArtistsPage> {
  @override
  Widget build(BuildContext context) {
    /// Doing this, so in case of unfollow of an artist, the list gets refetched
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  KKBackButton(),
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
                query: currentUser.savedArtists.isEmpty
                    ? UserDocService()
                        .usersCollection
                        .where(FieldPath.documentId, whereIn: ['EMPTY'])
                    : UserDocService().usersCollection.where(
                        FieldPath.documentId,
                        whereIn: currentUser.savedArtists),
                itemBuilder: (context, snapshot) {
                  return ArtistTile(
                    artist: snapshot.data(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
