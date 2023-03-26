import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/models/event.dart';
import 'package:event_finder/services/auth.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage.service.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:event_finder/widgets/kk_icon.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/app_user.dart';
import '../../../services/firestore_service.dart';
import 'location_snippet.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late Future<String> _imageUrl;
  @override
  Widget build(BuildContext context) {
    final Event event = Provider.of<StateService>(context).lastSelectedEvent!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: event.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  event.imageUrl!,
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KKIcon(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(event.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                    )),
                                Card(
                                  //color: primaryColor,
                                  child: SizedBox(
                                      width: 50,
                                      height: 30,
                                      child: Center(
                                        child: Text(
                                          '${event.ticketPrice} €',
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const KKIcon(
                          icon: Icon(Icons.access_time),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.date.toString().substring(0, 10)),
                            Text(
                                '${event.date.toString().substring(11, 16)} Uhr')
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            const KKIcon(icon: Icon(Icons.music_note)),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(event.genre),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (event.artists.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: IconButton(
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: FirestoreListView<AppUser>(
                                              emptyBuilder: (context) {
                                                return const Center(
                                                  child: Text('Keine Artists'),
                                                );
                                              },
                                              query: FirestoreService()
                                                  .usersCollection
                                                  .where(
                                                    FieldPath.documentId,
                                                    whereIn: event.artists,
                                                  ),
                                              itemBuilder: (context, snapshot) {
                                                final artist = snapshot.data();
                                                _imageUrl = StorageService()
                                                    .getUserImageUrl(
                                                        artist.uid);

                                                /// This is used twice, also in saved artists page TODO: merge into one widget
                                                return GestureDetector(
                                                  onTap: () {
                                                    StateService()
                                                            .lastSelectedArtist =
                                                        artist;
                                                    Navigator.pushNamed(
                                                        context, 'artist_page');
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: 4),
                                                      leading: FutureBuilder(
                                                          future: _imageUrl,
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasError) {
                                                              return CircleAvatar(
                                                                radius: 30,
                                                                backgroundImage:
                                                                    Image.asset(
                                                                            'assets/images/profile_placeholder.png')
                                                                        .image,
                                                              );
                                                            }
                                                            artist.imageUrl =
                                                                snapshot.data;
                                                            return CircleAvatar(
                                                              radius: 30,
                                                              backgroundImage: snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting
                                                                  ? null
                                                                  : artist.imageUrl !=
                                                                          null
                                                                      ? NetworkImage(
                                                                          artist
                                                                              .imageUrl!)
                                                                      : Image.asset(
                                                                              'assets/images/profile_placeholder.png')
                                                                          .image,
                                                              child: snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting
                                                                  ? const SizedBox(
                                                                      height:
                                                                          18,
                                                                      width: 18,
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    )
                                                                  : null,
                                                            );
                                                          }),
                                                      title: Text(
                                                          artist.displayName),
                                                      trailing: const Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 15,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side:
                                                            const BorderSide(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Schliessen'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.people)),
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      height: 200,
                      child: LocationSnippet(
                          coordinates: event.locationCoordinates)),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      child: SingleChildScrollView(
                          child: Text(
                        event.details,
                        style: const TextStyle(height: 1.5),
                      ))),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            if (AuthService().currentUser?.type == UserType.base)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: KKButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'buy_tickets');
                  },
                  buttonText: 'Tickets hier kaufen',
                ),
              ),
            if (AuthService().currentUser?.type == UserType.guest)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const Text(
                        'Du willst Tickets kaufen? Dann registriere Dich'),
                    const SizedBox(
                      height: 10,
                    ),
                    KKButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'activate_account');
                      },
                      buttonText: 'Aktiviere Account',
                    ),
                  ],
                ),
              ),
            if (event.creatorId == AuthService().currentUser!.uid)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: 200,
                  child: KKButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'edit_event');
                    },
                    buttonText: 'Event bearbeiten',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
