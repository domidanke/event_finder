import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/custom_icon_button.dart';
import 'package:event_finder/widgets/genre_card.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
              height: 400,
              width: 1000,
              decoration: BoxDecoration(
                image: artist.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(
                          artist.imageUrl!,
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      )
                    : null,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomIconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(artist.displayName,
                                  style: const TextStyle(
                                    fontSize: 32,
                                  )),
                              StreamBuilder(
                                  stream: UserDocService()
                                      .usersCollection
                                      .doc(artist.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Text(
                                        'No Data...',
                                      );
                                    } else {
                                      final x = snapshot.data!.data()!;
                                      return Text(
                                        '${x.follower.length} Follower',
                                        style: const TextStyle(fontSize: 14),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CustomIconButton(
                            color: Colors.blue,
                            icon: const Icon(Icons.facebook),
                            onPressed: () async {
                              if (artist.externalLinks.facebook.isEmpty) return;
                              final url =
                                  Uri.parse(artist.externalLinks.facebook);
                              await launchUrl(url);
                            },
                          ),
                          CustomIconButton(
                            color: Colors.orange,
                            icon: const Icon(Icons.whatshot),
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
                            color: Colors.pinkAccent,
                            icon: const Icon(Icons.camera_alt_outlined),
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
                      )
                    ],
                  ),
                ),
              )),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                artist.genres.map((genre) => GenreCard(text: genre)).toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            final currentUser = StateService().currentUser!;
            return FloatingActionButton.extended(
              onPressed: () async {
                if (!currentUser.savedArtists.contains(artist.uid)) {
                  await UserDocService().toggleFollowArtist(artist);
                  setState(() {
                    StateService().toggleSavedArtist(artist.uid);
                  });
                } else {
                  _showUnfollowSheet();
                }
              },
              backgroundColor: currentUser.savedArtists.contains(artist.uid)
                  ? Colors.grey
                  : null,
              elevation: 0,
              label: currentUser.savedArtists.contains(artist.uid)
                  ? const Text(
                      'Following',
                    )
                  : const Text(
                      'Follow',
                      style: TextStyle(color: primaryWhite),
                    ),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          if (StateService().currentUser!.type == UserType.host)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: KKButton(
                  onPressed: () {
                    print('');
                  },
                  buttonText: 'Anfrage schicken'),
            )
        ],
      ),
    );
  }

  void _showUnfollowSheet() {
    final AppUser artist = StateService().lastSelectedArtist!;
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => SizedBox(
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
