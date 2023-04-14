import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/models/enums.dart';
import 'package:event_finder/services/firestore/user_doc.service.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/kk_back_button.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:event_finder/widgets/kk_icon.dart';
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  KKBackButton(),
                ],
              ),
            ),
            CircleAvatar(
              radius: 100,
              backgroundImage: artist.imageUrl != null
                  ? NetworkImage(artist.imageUrl!)
                  : Image.asset('assets/images/profile_placeholder.png').image,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(artist.displayName),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KKIcon(
                  icon: const Icon(Icons.facebook),
                  onPressed: () async {
                    if (artist.externalLinks.facebook.isEmpty) return;
                    final url = Uri.parse(artist.externalLinks.facebook);
                    await launchUrl(url);
                  },
                ),
                KKIcon(
                  icon: const Icon(Icons.whatshot),
                  onPressed: () async {
                    if (artist.externalLinks.soundCloud.isEmpty) return;
                    final url = Uri.parse(artist.externalLinks.soundCloud);
                    await launchUrl(url);
                  },
                ),
                KKIcon(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () async {
                    if (artist.externalLinks.instagram.isEmpty) return;
                    final url = Uri.parse(artist.externalLinks.instagram);
                    await launchUrl(url);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              final currentUser = StateService().currentUser!;
              return FloatingActionButton.extended(
                onPressed: () async {
                  await UserDocService().followArtist(artist);
                  setState(() {
                    StateService().toggleSavedArtist(artist.uid);
                  });
                },
                backgroundColor: currentUser.savedArtists.contains(artist.uid)
                    ? Colors.grey
                    : null,
                elevation: 0,
                label: currentUser.savedArtists.contains(artist.uid)
                    ? const Text(
                        'Unfollow',
                      )
                    : const Text(
                        'Follow',
                        style: TextStyle(color: primaryWhite),
                      ),
                icon: currentUser.savedArtists.contains(artist.uid)
                    ? const Icon(Icons.cancel_outlined)
                    : const Icon(
                        Icons.person_add_alt_1,
                        color: primaryWhite,
                      ),
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Follower '),

                /// Maybe not the best solution, but shows live number of followers
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
                        return Text('${x.follower.length}');
                      }
                    })
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            if (StateService().currentUser!.type != UserType.host)
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'artist_events_page');
                  },
                  icon: const Icon(Icons.event)),
            const SizedBox(
              height: 20,
            ),
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
      ),
    );
  }
}
