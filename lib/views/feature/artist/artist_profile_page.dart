import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/artist/artist_edit_profile_page.dart';
import 'package:event_finder/views/feature/shared/saved_hosts_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/auth.service.dart';
import '../../../services/firestore/user_doc.service.dart';
import '../../../widgets/genre_card.dart';

class ArtistProfilePage extends StatefulWidget {
  const ArtistProfilePage({Key? key}) : super(key: key);

  @override
  State<ArtistProfilePage> createState() => _ArtistProfilePageState();
}

class _ArtistProfilePageState extends State<ArtistProfilePage> {
  late Future<String> _imageUrl;

  @override
  void initState() {
    _imageUrl = StorageService().getProfileImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    _imageUrl = StorageService().getProfileImageUrl();
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: FutureBuilder(
              future: _imageUrl,
              builder: (context, snapshot) {
                currentUser.imageUrl = snapshot.data;
                if (snapshot.hasData) {
                  return CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                      currentUser.imageUrl!,
                    ),
                  );
                } else {
                  return Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: primaryWhite.withOpacity(0.2), width: 0.2),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          currentUser.displayName,
          style: const TextStyle(fontSize: 22),
        ),
        const SizedBox(
          height: 4,
        ),
        StreamBuilder(
            stream: UserDocService()
                .usersCollection
                .doc(currentUser.uid)
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
          height: 12,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: currentUser.genres
              .map((genre) => GenreCard(text: genre))
              .toList(),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
            child: ListView(
          children: [
            Opacity(
              opacity: currentUser.savedHosts.isEmpty ? 0.4 : 1,
              child: ListTile(
                leading: const Icon(Icons.house),
                title: const Text('Meine Hosts'),
                onTap: () {
                  if (currentUser.savedHosts.isEmpty) {
                    return;
                  }
                  showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) => const SavedHostsPage(),
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.event_available),
              title: const Text('Meine Events'),
              onTap: () {
                Navigator.pushNamed(context, 'artist_events_page');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Profil bearbeiten'),
              onTap: () {
                showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) =>
                      const ArtistEditProfilePage(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_mark),
              title: const Text('Support'),
              onTap: () {
                Navigator.pushNamed(context, 'support_page');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await AuthService().signOut().then((value) => {
                      StateService().resetCurrentUserSilent(),
                      Navigator.popUntil(context,
                          (Route<dynamic> route) => route.settings.name == '/'),
                    });
              },
            ),
          ],
        )),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
