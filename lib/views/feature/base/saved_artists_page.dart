import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/firestore_service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage.service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class SavedArtistsPage extends StatefulWidget {
  const SavedArtistsPage({super.key});

  @override
  State<SavedArtistsPage> createState() => _SavedArtistsPageState();
}

class _SavedArtistsPageState extends State<SavedArtistsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FirestoreListView<AppUser>(
          emptyBuilder: (context) {
            return const Center(
              child: Text('Keine Artists'),
            );
          },
          query: FirestoreService().usersCollection.where(FieldPath.documentId,
              whereIn: AuthService().currentUser!.savedArtists),
          itemBuilder: (context, snapshot) {
            AppUser artist = snapshot.data();
            return GestureDetector(
              onTap: () {
                StateService().lastSelectedArtist = artist;
                Navigator.pushNamed(context, 'artist_page');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: 4),
                  leading: FutureBuilder(
                      future: StorageService().getUserImageUrl(artist.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return CircleAvatar(
                            radius: 100,
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
            );
          },
        ),
      ),
    );
  }
}
