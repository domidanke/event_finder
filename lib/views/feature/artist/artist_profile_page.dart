import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
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
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: _imageUrl,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              currentUser.imageUrl = snapshot.data;
              if (snapshot.hasData) {
                return Container(
                    height: 400,
                    width: 1000,
                    decoration: BoxDecoration(
                      image: currentUser.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(
                                currentUser.imageUrl!,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(currentUser.displayName,
                                        style: const TextStyle(
                                          fontSize: 32,
                                        )),
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
                                            return Row(
                                              children: [
                                                Text(
                                                  '${x.follower.length} Follower',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ],
                                            );
                                          }
                                        }),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
              } else {
                return const SizedBox(
                  height: 400,
                  width: 1000,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: currentUser.genres
                .map((genre) => GenreCard(text: genre))
                .toList(),
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
                    Navigator.pushNamed(context, 'saved_hosts');
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
                  Navigator.pushNamed(context, 'artist_edit_profile');
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
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (Route<dynamic> route) => false),
                      });
                },
              ),
            ],
          )),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
