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
              radius: 50,
              backgroundImage: artist.imageUrl != null
                  ? NetworkImage(artist.imageUrl!)
                  : Image.asset('assets/images/profile_placeholder.png').image,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              artist.displayName,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: artist.genres
                  .map((e) => Card(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            child: Text(e)),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
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
                          '${x.follower.length}',
                          style: const TextStyle(fontSize: 20),
                        );
                      }
                    }),
                const Text('Follower')
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
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KKIcon(
                  color: Colors.blue,
                  icon: const Icon(Icons.facebook),
                  onPressed: () async {
                    if (artist.externalLinks.facebook.isEmpty) return;
                    final url = Uri.parse(artist.externalLinks.facebook);
                    await launchUrl(url);
                  },
                ),
                KKIcon(
                  color: Colors.orange,
                  icon: const Icon(Icons.whatshot),
                  onPressed: () async {
                    if (artist.externalLinks.soundCloud.isEmpty) return;
                    final url = Uri.parse(artist.externalLinks.soundCloud);
                    await launchUrl(url);
                  },
                ),
                KKIcon(
                  color: Colors.pinkAccent,
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
