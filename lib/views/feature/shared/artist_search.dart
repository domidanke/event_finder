import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage.service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/firestore_service.dart';

class ArtistSearch extends StatefulWidget {
  const ArtistSearch({super.key});

  @override
  State<ArtistSearch> createState() => _ArtistSearchState();
}

class _ArtistSearchState extends State<ArtistSearch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreListView<AppUser>(
      emptyBuilder: (context) {
        return const Center(
          child: Text('Keine Artists'),
        );
      },
      query: FirestoreService().usersCollection.where(
            'type',
            isEqualTo: 'artist',
          ),
      itemBuilder: (context, snapshot) {
        final artist = snapshot.data();

        /// This is used twice, also in saved artists page TODO: merge into one widget
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
                        backgroundImage:
                            Image.asset('assets/images/profile_placeholder.png')
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
                      child: snapshot.connectionState == ConnectionState.waiting
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
    );
  }
}
