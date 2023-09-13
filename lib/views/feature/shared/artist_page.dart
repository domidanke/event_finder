import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/firestore/event_doc.service.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/genre_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/event.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../../widgets/event_tile.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({Key? key}) : super(key: key);

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  @override
  Widget build(BuildContext context) {
    final AppUser artist =
        Provider.of<StateService>(context).lastSelectedArtist!;
    Provider.of<StateService>(context).isLoadingFollow;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                          size: 2,
                          color: primaryWhite,
                          icon: const Icon(
                            Icons.facebook,
                            size: 16,
                          ),
                          onPressed: () async {
                            if (artist.externalLinks.facebook.isEmpty) return;
                            final url =
                                Uri.parse(artist.externalLinks.facebook);
                            await launchUrl(url);
                          },
                        ),
                        CustomIconButton(
                          size: 2,
                          color: primaryWhite,
                          icon: const Icon(Icons.whatshot, size: 16),
                          onPressed: () async {
                            if (artist.externalLinks.soundCloud.isEmpty) {
                              return;
                            }
                            final url =
                                Uri.parse(artist.externalLinks.soundCloud);
                            await launchUrl(url);
                          },
                        ),
                        CustomIconButton(
                          size: 2,
                          color: primaryWhite,
                          icon: const Icon(Icons.camera_alt_outlined, size: 16),
                          onPressed: () async {
                            if (artist.externalLinks.instagram.isEmpty) {
                              return;
                            }
                            final url =
                                Uri.parse(artist.externalLinks.instagram);
                            await launchUrl(url);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    artist.imageUrl != null && artist.imageUrl!.isNotEmpty
                        ? NetworkImage(artist.imageUrl!)
                        : Image.asset('assets/images/profile_placeholder.png')
                            .image,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                artist.displayName,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(
                height: 8,
              ),
              if (!StateService()
                  .currentUser!
                  .savedArtists
                  .contains(artist.uid))
                GestureDetector(
                  onTap: () async {
                    StateService().isLoadingFollow = true;
                    await UserDocService().toggleFollowArtist(artist);
                    StateService().isLoadingFollow = false;
                    setState(() {
                      StateService().toggleSavedArtist(artist.uid);
                    });
                  },
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Card(
                      color: secondaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: secondaryColor, width: 1),
                      ),
                      child: Center(
                          child: StateService().isLoadingFollow
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: primaryBackgroundColor,
                                  ))
                              : const Text(
                                  'Follow',
                                  style:
                                      TextStyle(color: primaryBackgroundColor),
                                )),
                    ),
                  ),
                ),
              if (StateService().currentUser!.savedArtists.contains(artist.uid))
                GestureDetector(
                  onTap: () {
                    _showUnfollowSheet();
                  },
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: secondaryColor, width: 1),
                      ),
                      child: Center(
                          child: StateService().isLoadingFollow
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: secondaryColor,
                                  ))
                              : const Text(
                                  'Following',
                                  style: TextStyle(color: secondaryColor),
                                )),
                    ),
                  ),
                ),
              const SizedBox(
                height: 8,
              ),
              StreamBuilder(
                  stream: UserDocService()
                      .usersCollection
                      .doc(artist.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text(
                        '',
                      );
                    } else {
                      final x = snapshot.data!.data()!;
                      return Text(
                        '${x.follower.length} Follower',
                        style: const TextStyle(fontSize: 14),
                      );
                    }
                  }),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: artist.genres
                    .map((genre) => GenreCard(text: genre))
                    .toList(),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nächste Events',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Expanded(
                child: FirestoreListView<Event>(
                  emptyBuilder: (context) {
                    return const Center(
                      child: Text('Keine Events'),
                    );
                  },
                  query: _getArtistEventsQuery(artist),
                  itemBuilder: (context, snapshot) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: EventTile(event: snapshot.data()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Query<Event> _getArtistEventsQuery(AppUser artist) {
    return EventDocService()
        .eventsCollection
        .where('artists', arrayContains: artist.uid)
        .orderBy('startDate');
  }

  void _showUnfollowSheet() {
    final AppUser artist = StateService().lastSelectedArtist!;
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        height: 100,
        child: ListTile(
          leading: const Icon(Icons.cancel_outlined),
          onTap: () async {
            await UserDocService().toggleFollowArtist(artist);
            setState(() {
              StateService().toggleSavedArtist(artist.uid);
            });
            if (mounted) Navigator.pop(context);
          },
          title: const Text('Unfollow'),
        ),
      ),
    );
  }
}
