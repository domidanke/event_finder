import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/host/host_edit_profile_page.dart';
import 'package:event_finder/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/app_user.dart';
import '../../../services/alert.service.dart';
import '../../../services/auth.service.dart';
import '../../../services/firestore/user_doc.service.dart';
import '../../../services/state.service.dart';
import '../../../services/storage/storage.service.dart';

class HostHomePage extends StatefulWidget {
  const HostHomePage({super.key});
  @override
  State<HostHomePage> createState() => _HostHomePageState();
}

class _HostHomePageState extends State<HostHomePage> {
  late Future<String> _imageUrl;
  @override
  Widget build(BuildContext context) {
    final AppUser currentUser = Provider.of<StateService>(context).currentUser!;
    _imageUrl = StorageService().getProfileImageUrl();
    return WillPopScope(
        onWillPop: () async => !Navigator.of(context).userGestureInProgress,
        child: Column(
          children: [
            FutureBuilder(
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
            Expanded(
                flex: 8,
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.local_fire_department_outlined),
                      title: const Text('Aktuelle Events'),
                      onTap: () {
                        Navigator.pushNamed(context, 'current_events');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time_outlined),
                      title: const Text('Vergangene Events'),
                      onTap: () {
                        Navigator.pushNamed(context, 'past_events');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.search),
                      title: const Text('Künstlersuche'),
                      onTap: () {
                        Navigator.pushNamed(context, 'artist_search');
                      },
                    ),
                    Opacity(
                      opacity: currentUser.savedArtists.isEmpty ? 0.4 : 1,
                      child: ListTile(
                        leading: const Icon(Icons.people),
                        title: const Text('Meine Künstler'),
                        onTap: () {
                          if (currentUser.savedArtists.isEmpty) {
                            return;
                          }
                          Navigator.pushNamed(context, 'saved_artists');
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Profil bearbeiten'),
                      onTap: () {
                        showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) =>
                              const HostEditProfilePage(),
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
                              Navigator.pushNamedAndRemoveUntil(context, '/',
                                  (Route<dynamic> route) => false),
                            });
                      },
                    ),
                  ],
                )),
            SizedBox(
              width: 150,
              child: CustomButton(
                onPressed: () {
                  if (!StateService().isProfileComplete()) {
                    AlertService().showAlert(
                        'Noch nicht möglich', 'profile_incomplete', context);
                  } else {
                    Navigator.pushNamed(context, 'create_event_page');
                  }
                },
                buttonText: 'Event erstellen',
              ),
            ),
          ],
        ));
  }
}
