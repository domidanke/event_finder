import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../models/app_user.dart';
import '../../../../services/firestore_service.dart';
import '../../../../services/state.service.dart';
import '../../../../services/storage.service.dart';

class CreateEventPage4 extends StatefulWidget {
  const CreateEventPage4({Key? key}) : super(key: key);

  @override
  State<CreateEventPage4> createState() => _CreateEventPage4State();
}

class _CreateEventPage4State extends State<CreateEventPage4> {
  late Future<String> _imageUrl;
  List<String> selectedArtists = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FirestoreListView<AppUser>(
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
                          value: selectedArtists.contains(artist.uid),
                          onChanged: (v) {
                            setState(() {
                              selectedArtists.contains(artist.uid)
                                  ? selectedArtists.remove(artist.uid)
                                  : selectedArtists.add(artist.uid);
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
        ));
  }
}
