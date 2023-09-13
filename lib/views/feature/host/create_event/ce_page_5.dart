import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/search_page.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/widgets/user_search_field.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/app_user.dart';
import '../../../../services/create_event.service.dart';
import '../../../../services/storage/storage.service.dart';
import '../../../../theme/theme.dart';

class CePage5 extends StatefulWidget {
  const CePage5({Key? key}) : super(key: key);

  @override
  State<CePage5> createState() => _CePage5State();
}

class _CePage5State extends State<CePage5> {
  late Future<String> _imageUrl;

  @override
  Widget build(BuildContext context) {
    Provider.of<SearchService>(context).searchText;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          const SizedBox(
            height: 6,
          ),
          Row(
            children: const [
              Expanded(
                  child: UserSearchField(
                hintText: 'Künstler',
              )),
            ],
          ),
          if (SearchService().searchText.isNotEmpty)
            Expanded(
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
                              return Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    checkColor: primaryBackgroundColor,
                                    value: CreateEventService()
                                        .newEvent
                                        .enlistedArtists
                                        .contains(artist.uid),
                                    onChanged: (v) {
                                      setState(() {
                                        if (CreateEventService()
                                            .newEvent
                                            .enlistedArtists
                                            .contains(artist.uid)) {
                                          CreateEventService()
                                              .newEvent
                                              .enlistedArtists
                                              .remove(artist.uid);
                                        } else {
                                          CreateEventService()
                                              .newEvent
                                              .enlistedArtists
                                              .add(artist.uid);
                                        }
                                      });
                                    }),
                              );
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
        ],
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
    return query = query
        .where('displayName',
            isGreaterThanOrEqualTo: SearchService().searchText)
        .where('displayName', isLessThan: '${SearchService().searchText}z');
  }
}
