import 'package:event_finder/models/app_user.dart';
import 'package:event_finder/services/state.service.dart';
import 'package:event_finder/services/storage/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/auth.service.dart';
import '../../../widgets/kk_button.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      currentUser.imageUrl != null
                          ? CircleAvatar(
                              radius: 100,
                              backgroundImage:
                                  NetworkImage(currentUser.imageUrl!))
                          : FutureBuilder(
                              future: _imageUrl,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return CircleAvatar(
                                    radius: 100,
                                    backgroundImage: Image.asset(
                                            'assets/images/profile_placeholder.png')
                                        .image,
                                  );
                                }
                                currentUser.imageUrl = snapshot.data;
                                if (snapshot.hasData) {
                                  return CircleAvatar(
                                    radius: 100,
                                    backgroundImage: snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? null
                                        : currentUser.imageUrl != null
                                            ? NetworkImage(
                                                currentUser.imageUrl!)
                                            : Image.asset(
                                                    'assets/images/profile_placeholder.png')
                                                .image,
                                    child: snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? const CircularProgressIndicator()
                                        : null,
                                  );
                                } else {
                                  return const SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CircularProgressIndicator());
                                }
                              }),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(currentUser.displayName.isEmpty
                            ? '- kein Name'
                            : currentUser.displayName),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: currentUser.genres
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
                      const Divider(),
                    ],
                  )),
              Expanded(
                  flex: 8,
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
                    ],
                  )),
              KKButton(
                  onPressed: () async {
                    await AuthService().signOut().then((value) => {
                          StateService().resetCurrentUserSilent(),
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (Route<dynamic> route) => false),
                        });
                  },
                  buttonText: 'Abmelden'),
            ],
          ),
        ),
      ),
    );
  }
}
